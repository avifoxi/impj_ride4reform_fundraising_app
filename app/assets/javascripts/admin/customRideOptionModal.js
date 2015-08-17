/*
	INSTANTIATED IN admin/ride_year/edit , allows adding + editing + viewing custom ride options

*/ 

var CustomRideOptionModalCtrl = function(c_r_o_ids) {
	// customRideOption ids passed in via json in view.
	var $modal = $('.modal'),
		$title = $('.modal-title'),
		$body = $('.modal-body'),
		$footer = $('.modal-footer'),
		_views = {
			'new': $('#new_custom_ride_option').html(),
			'show': {},
			'edit': {}
		};

	_.each(c_r_o_ids, function(id){
		_views['show'][id.toString()] = $('#show_c_r_o_' + id).html();
		_views['edit'][id.toString()] = $('#edit_c_r_o_' + id).html();
	});

	this.showViews = function(){
		return _views;
	}
	this.showCroIds = function(){
		return c_r_o_ids;
	}

	$('a[data-custom_ride_option]').click(function(e){
		e.preventDefault();
		// all relevant buttons in view are tagged with data for this controller 
		handleClick( $(e.target).attr('data-custom_ride_option') );	
	});

	function handleClick(dataAttr) {
		var splat = dataAttr.split('_'),
			action = splat[0],
			id = splat[1],
			selectedView;

		switch ( action ){
			case 'new':
				selectedView = _views['new'];
				break;
			case 'edit':
				selectedView = _views['edit'][id];
				break;
			case 'show':
				selectedView = _views['show'][id];
				break;
		}
		render(selectedView, action, id);
	};

	function render(selectedView, action, id){
		$title.html(action + ' Custom Ride Option ' + id);
		$body.html(selectedView);
		$footer = '';
		$modal.modal();
	};
}

