getCurrentPlaylist = function() {
	var data = []
	$('.my-playlist .to-my-playlist:checked').each(function(){
		var $mySong = $(this).next('.my-song')
		data.push({title: $mySong.text(), mp3: $mySong.data('lien')})
	})
	console.log("la fonction getCurrentPlaylist est ok")
	return data
}

rebuildPlaylist = function() {
	console.log('rebuild the playlist')
	myPlaylist.setPlaylist(getCurrentPlaylist())
	console.log("la fonction rebuildPlaylist est ok")
}

resetVotes = function(){
	console.log('dand reset votes')
	$('#vote_1').text(0)
	$('#vote_2').text(0)
	$('#vote_3').text(0)
}

refreshVotes = function(){
	console.log('dans refresh votes')
	$.get('/update_vote', function(data) {
		votes = JSON.parse(data)
		console.log('dans votes: ')
		console.log(votes)
		if(votes != "stop polling") {
			$('#vote_1').text(votes.vote_1)
			$('#vote_2').text(votes.vote_2)
			$('#vote_3').text(votes.vote_3)
			setTimeout(refreshVotes,5000)
		}
	});
}

refreshTweets = function() {
	$("#conteneur_tweet").load("/fresh_tweets", function() {
		setTimeout(refreshTweets,5000) 
	})
} 

$(document).ready(function(){
	rebuildPlaylist()

	// refreshTweets()

	$("#my-tracks").sortable({
		axis: "y",
		update: function() {
			var tracks = []
			$(".my-playlist .my-song").each(function(){
				tracks.push({title: $(this).text(), mp3: $(this).data('lien')})
			})
			$.post("/sort_url", {'tracks': tracks}, function(data) {
				rebuildPlaylist()
			})
		}
	})

	$('.to-my-playlist').on('change', function(event) {
		rebuildPlaylist()
	})

	$('.remove-my-song').on('click', function(event) {
		console.log('into remove my song')
		event.preventDefault()
		var name = $(this).prev('.my-song').text()
		$.post('/remove_track', {name: name})
		$(this).parent().remove()
		rebuildPlaylist()
	})

	$('#stop_and_go_votes').on('click', function(event) { 
		event.preventDefault()
		data = {hash1: $('#hash1').val(), 
		hash2: $('#hash2').val(), 
		hash3: $('#hash3').val()}
		console.log(data)
		$.post('/vote', data, function(data) {
			$('#stop_and_go_votes').text(data)
			$('.songhashtag').removeAttr('readonly')
			$('#stop_and_go_votes').toggleClass("btn-success")
			$('#stop_and_go_votes').toggleClass("btn-danger")
			if(data == "Arrêter") {	
				$('.songhashtag').attr('readonly', 'true')
				resetVotes()
				refreshVotes() 
			}
		})
		console.log('done')
	})

	if($('#stop_and_go_votes').hasClass('btn-danger')) {
		console.log('vote en cours')
		refreshVotes()
	} 


	$("#remise_a_zero").on('click', function(event) {
		$.post("/remettre_a_zero", function(){
			$('#vote_1').text(0)
			$('#vote_2').text(0)
			$('#vote_3').text(0)
		})
	})

});
