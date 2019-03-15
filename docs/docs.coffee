
# components

TileGrid = require '../components/TileGrid.coffee'

global.log = console.log.bind(console)
require 'normalize.css'
StateHandle = require 'simple-state-handle'
{Component,createElement} = require 'react'
Slide = require 're-slide'

rlite = require('rlite-router')


require './docs.less'


h = createElement


class Interface extends StateHandle
	constructor: (props)->
		super(props)
		@state = {}
			
		# @route = rlite @setState.bind(@,new Error 'not found'),
		# 	'/': @showHome
		# 	'/demo/:module': @showModule

		# window.addEventListener('hashchange', @processHash)


	# nav: (hash)=>
	# 	hash = hash || '/'
	# 	window.location.hash = '#'+hash
	# 	@route hash


	# processHash: =>
	# 	hash = location.hash || '#'
	# 	@route hash.slice 1


	# showHome: =>
	# 	@setState
	# 		show_module: null


	# showModule: (params)=>
	# 	@setState
	# 		show_module: params.module







class Docs extends Component
	constructor: (props)->
		super(props)
		@state =
			items: [0...100].map (i)->
				return
					index: i
					width: Math.floor(1+Math.random()*2)
					height: Math.floor(1+Math.random()*2)

	render: ->
		grid_list = h TileGrid,
			item_count: 10
			width: 6
			height: -1
			getItemWidth: (index)->
				@state.items[index].width

			getItemHeight: (index)->
				@state.items[index].height

			renderItem: (opt)->
				h 'div',
					key: opt.key
					className: 'grid-item'
					style:
						left: opt.x
						top: opt.y
						width: opt.width
						height: opt.height
						background: 'rgba(255,255,255,'+((i.index%10)/10)+')'
					h 'span',{},opt.key


		h Slide,
			beta: 100
			className: 'docs-slide'			
			vert: yes
			center: yes
			grid_list




window.face = new Interface
	view: Docs
	el: window.docs

# face.processHash()


face.render()