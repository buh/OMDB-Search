//
//  OMDetailViewController.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "OMDetailViewController.h"
#import "OMDetailRequest.h"
#import "OMMacros.h"
#import "UIImageView+AFNetworking.h"
#import "OMNavigationController.h"

@interface OMDetailViewController ()

@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic) OMDetailRequest *detailRequest;

@end

@implementation OMDetailViewController

- (void)dealloc
{
    [_detailRequest cancel];
}

- (void)setMovieViewModel:(OMMovieViewModel *)movieViewModel
{
    _movieViewModel = movieViewModel;
    self.title = _movieViewModel.title;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_movieViewModel) {
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    if (!_movieViewModel.isFull) {
        [self setupActivityIndicatorView];
        [self setupDetailRequest];
    }
    
    [self updateLabels];
}

- (void)updateLabels
{
    _yearLabel.text = _movieViewModel.year;
    _countryLabel.text = _movieViewModel.country;
    _awardsLabel.text = _movieViewModel.awards;
    _genreLabel.text = _movieViewModel.genre;
    _directorLabel.text = _movieViewModel.director ?: @"N/A";
    _writerLabel.text = _movieViewModel.writer ?: @"N/A";
    _actorsLabel.text = _movieViewModel.actors ?: @"N/A";
    _plotLabel.text = _movieViewModel.plot;
    
    if (!_posterImageView.image && _movieViewModel.posterURL) {
        [_posterImageView setImageWithURL:_movieViewModel.posterURL];
    }
}

- (void)setupActivityIndicatorView
{
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_activityIndicatorView];
}

- (void)setupDetailRequest
{
    OMWeakSelf;
    _detailRequest = [[OMDetailRequest alloc] initWithMovieViewModel:_movieViewModel
                                                     completionBlock:^(OMMovieViewModel *movieViewModel, NSError *error) {
                                                         OMStrongSelf;
                                                         [strongSelf.activityIndicatorView stopAnimating];
                                                         [strongSelf updateLabels];
                                                     }];
    
    [self sendRequest];
}

- (void)sendRequest
{
    if (_movieViewModel.isFull) {
        return;
    }
    
    if (![((OMNavigationController *)self.navigationController) checkInternetConnetionReachabilityAndShowAlert:YES]) {
        return;
    }
    
    [_activityIndicatorView startAnimating];
    [_detailRequest sendRequest];
}

- (void)badInternetConnectionRetryRequest
{
    [self sendRequest];
}

@end
