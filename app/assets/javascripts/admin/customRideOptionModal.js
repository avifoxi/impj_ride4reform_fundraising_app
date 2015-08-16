/*
	INSTANTIATED IN admin/ride_year/edit , allows adding + editing + viewing custom ride options

*/ 

var CustomRideOptionModalCtrl = function(customRideOptions) {
	// customRideOptions passed in via json in view.
	var $modal = $('.modal'),
		$title = $('.modal-title'),
		$body = $('.modal-body'),
		$footer = $('.modal-footer'),
		$c_r_oFormHtml = $('#custom_ride_option_form').html(),
		$c_r_oShowHtml = $('#custom_ride_option_show').html(), 
		$cueButtons = $('a[data]'),
		
		_actionContentMap = {
			'new': $c_r_oFormHtml,
			'show': $c_r_oShowHtml,
			'edit': $c_r_oFormHtml
		},
		_modalIsShowing = false,
		_quickFind = {};

	_.each(customRideOptions, function(opt){
		_quickFind[opt.id] = opt;
	});

	$cueButtons.click(function(e){
		e.preventDefault();
		// all relevant buttons in view are tagged with data for this controller 
		handleClick( $(e.target).attr('data') );	
	});

	function handleClick(dataAttr) {
		// eventually, perhaps more options, and switch statement makes more sense
		// but right now, just 2. 
		if ( dataAttr === 'newCustomRideOption'){
			$title.html( 'New Custom Ride Option');
			$body.html( $c_r_oFormHtml );
			$modal.modal();
		} else {
			var splat = dataAttr.split('_'),
				action = splat[0],
				id = splat[1];

			parseAttr(action, id);
		}
	};

	function parseAttr(action, id){
		var myOption = _quickFind[+id];


	};

	function actionShow(){

	};

	function actionEdit(){

	};


}

