//
//  ViewController.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 15.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "OMMacros.h"
#import "OMViewController.h"
#import "OMSearchRequest.h"
#import "NSString+OMSearch.h"
#import "OMDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "OMNavigationController.h"
#import "OMThumbnailImageCache.h"

static NSString *const OMViewControllerTableCellIdentifier = @"movieListCellIdentifier";

@interface OMViewController () <UISearchBarDelegate>

@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) OMSearchRequest *currentSearchRequest;
@property (nonatomic) NSCache *searchRequestsCache;
@property (nonatomic) OMThumbnailImageCache *thumbnailImageCache;

@end

@implementation OMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 60.;
    
    _searchRequestsCache = [NSCache new];
    _thumbnailImageCache = [[OMThumbnailImageCache alloc] initWithThumbnailSize:CGSizeMake(self.tableView.rowHeight,
                                                                                           self.tableView.rowHeight)];
    
    [self setupActivityIndicatorView];
    [self setupSearchBar];
}

- (void)setupActivityIndicatorView
{
    // Setup Activity Indicator view.
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];
    
    // Setup Cancel button.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(cancelSearch)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)setupSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"Movie Title";
    self.navigationItem.titleView = _searchBar;
    
    [_searchBar becomeFirstResponder];
}

#pragma mark - Search

- (void)search
{
    if (![((OMNavigationController *)self.navigationController) checkInternetConnetionReachabilityAndShowAlert:YES]) {
        [self cancelSearch];
        
        return;
    }
    
    NSString *searchText = [_searchBar.text om_searchText];
    
    if (!searchText.length) {
        // TODO: Show warning.
        return;
    }
    
    if ([_currentSearchRequest.searchText isEqualToString:searchText]) {
        [_currentSearchRequest search];
        
        return;
    }
    
    [_activityIndicatorView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    _currentSearchRequest = [self createSearchRequestWithSearchText:searchText];
    [_currentSearchRequest search];
}

- (OMSearchRequest *)createSearchRequestWithSearchText:(NSString *)searchText
{
    OMSearchRequest *searchRequest = [_searchRequestsCache objectForKey:searchText];
    
    if (!searchRequest) {
        OMWeakSelf;
        searchRequest = [[OMSearchRequest alloc] initWithSearchText:searchText
                                                    completionBlock:^(NSArray<OMMovieViewModel *> *results,
                                                                      NSUInteger page,
                                                                      NSError *error) {
                                                        OMStrongSelf;
                                                        [strongSelf.activityIndicatorView stopAnimating];
                                                        strongSelf.navigationItem.rightBarButtonItem.enabled = NO;
                                                        [strongSelf.tableView reloadData];
                                                    }];
        
        [_searchRequestsCache setObject:searchRequest forKey:searchText];
    }
    
    return searchRequest;
}

- (void)cancelSearch
{
    [_activityIndicatorView stopAnimating];
    [_currentSearchRequest cancel];
    [_thumbnailImageCache cancel];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - Search Bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    [self search];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(nonnull NSString *)searchText
{
    if (!searchBar.text.length) {
        [self cancelSearch];
        [self.tableView reloadData];
    }
}

#pragma mark - Table View Data Source / Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = 0;
    
    if (_currentSearchRequest && [[_searchBar.text om_searchText] isEqualToString:_currentSearchRequest.searchText]) {
        count = _currentSearchRequest.results.count;
    }
    
    return count > 0 ? (count + (_currentSearchRequest.hasMore ? 1 : 0)) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:OMViewControllerTableCellIdentifier];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OMMovieViewModel *movieViewModel = nil;
    cell.imageView.image = nil;
    
    if (indexPath.row < _currentSearchRequest.results.count) {
        movieViewModel = _currentSearchRequest.results[indexPath.row];
        cell.textLabel.text = movieViewModel.title;
        cell.detailTextLabel.text = movieViewModel.year;
        
        if (movieViewModel.posterURL) {
            [self updateImageInCell:cell posterURL:movieViewModel.posterURL];
        }
        
    } else if (_currentSearchRequest.hasMore) {
        cell.imageView.image = nil;
        cell.textLabel.text = @"Loading...";
        cell.detailTextLabel.text = @"";
        
        [_activityIndicatorView startAnimating];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [_currentSearchRequest loadNextPage];
        
    } else {
        cell.imageView.image = nil;
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
}

- (void)updateImageInCell:(UITableViewCell *)cell posterURL:(NSURL *)posterURL
{
    __weak UITableViewCell *weackCell = cell;
    OMWeakSelf;
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:posterURL]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       __weak UITableViewCell *strongCell = weackCell;
                                       OMStrongSelf;
                                       
                                       UIImage *thumbnailImage = [strongSelf.thumbnailImageCache thumbnailImageWithURL:posterURL];
                                       
                                       if (thumbnailImage) {
                                           strongCell.imageView.image = thumbnailImage;
                                           [strongCell setNeedsLayout];
                                       } else {
                                           __weak UITableViewCell *weackCell = strongCell;
                                           [strongSelf.thumbnailImageCache processImage:image
                                                                                    URL:request.URL
                                                                        completionBlock:^(NSURL *imageURL, UIImage *thumbnailImage) {
                                                                            __weak UITableViewCell *strongCell = weackCell;
                                                                            
                                                                            if ([posterURL isEqual:imageURL]) {
                                                                                strongCell.imageView.image = thumbnailImage;
                                                                                [strongCell setNeedsLayout];
                                                                            }
                                                                        }];
                                       }
                                   } failure:NULL];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([_searchBar isFirstResponder]) {
        [_searchBar resignFirstResponder];
        [self.tableView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath) {
        OMDetailViewController *detailViewController = segue.destinationViewController;
        
        if (indexPath.row < _currentSearchRequest.results.count
            && [detailViewController isKindOfClass:[OMDetailViewController class]]) {
            detailViewController.movieViewModel = _currentSearchRequest.results[indexPath.row];
        }
    }
}

#pragma mark - Internet Connection

- (void)badInternetConnectionRetryRequest
{
    [self search];
}

@end
