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

refresh_votes = function(){
	console.log('dans refresh votes')
	$.get('/update_vote', function(data) {
		votes = JSON.parse(data)
		console.log('dans votes: ')
		console.log(votes)
		if(votes != "stop polling") {
			$('#vote_1').text(votes.vote_1)
			$('#vote_2').text(votes.vote_2)
			$('#vote_3').text(votes.vote_3)
			setTimeout(refresh_votes,5000)
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

	refreshTweets()

	$("#jp_container_N .jp-playlist").on("click", "a.jp-playlist-item-remove", function(){
		var name = $(this).next('.jp-playlist-item').text()

		$.post("/remove_track", {name: name}, function() {console.log('ok destroy')
		})
	})

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
		event.preventDefault()
		var name = $(this).prev('.my-song').text()
		if($(this).parent('li').find('.to-my-playlist')) { 
			rebuildPlaylist()
			$.post('http://localhost:9393/remove_track', {name: name}, function() {console.log('ok destroy')})
			$(this).parent().remove()}
		})

	$('#stop_and_go_votes').on('click', function(event) { 
		event.preventDefault()
		if($(this).hasClass('btn-success')) {
			$.post('/vote', {demarrer: "on"}, function() {
				$('#stop_and_go_votes').text('Arrêter')
				$('#stop_and_go_votes').removeClass("btn-success")
				$('#stop_and_go_votes').addClass("btn-danger")
				console.log('vote started')
				refresh_votes() 
			})
		} else {
			$.post('/vote', {demarrer: "off"}, function() {
				$('#stop_and_go_votes').text('Démarrer')
				$('#stop_and_go_votes').removeClass("btn-danger")
				$('#stop_and_go_votes').addClass("btn-success")
				console.log('vote stopped')
			})
		}
		console.log('done')
	})

	$("#remise_a_zero").on('click', function(event) {
		$.post("/remettre_a_zero", function(){
			$('#vote_1').text(0)
			$('#vote_2').text(0)
			$('#vote_3').text(0)
		})
	})

})
