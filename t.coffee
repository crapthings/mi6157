# 
@col1 = new Mongo.Collection 'col1'

# 
if Meteor.isClient

	Template.tp1.helpers
		'test': -> do col1.findOne

	Template.tp1.onCreated ->
		console.log 'template tp1 created'
		@subscribe 'getCol1'

	Template.tp1.onRendered ->
		
		console.log 'run only once and data not there', do col1.findOne

		@autorun =>

			data = do col1.findOne

			console.log 'will rerun when data arrived', data

			# do jquery here
			console.log $('#jqueryContainer').text($('#jqueryContainer').text() + ' ' + data.text) if data?.text
			console.log $('#jqueryContainer').append('<p>jquery append a p to dom</p>') if data?.text

# 
if Meteor.isServer

	# npm on server
	Future = Npm.require 'fibers/future'

	# Simulate high latency publish
	Meteor.publish 'getCol1', ->

		future = new Future

		Meteor.setTimeout ->
			future.return do col1.find
		, 2000

		do future.wait

	# add data after server startup
	Meteor.startup ->
		console.log('\n do we have data in col1 \n', do col1.findOne)
		unless do col1.findOne
			console.log 'add data to col1'
			col1.insert
				text: 'blah blah blah'

