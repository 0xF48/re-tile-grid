{createElement,Component} = require 'react'
require './TileGrid.less'

{TileGrid,Tile,Rect} = require 'tile-grid-util'
TileGrid2 = TileGrid



class TileGrid extends Component
	constructor: (props)->
		super(props)
		@state = 
			p_offset: 0
			scroll_start_beta: .35
			scroll_end_beta: .65

	componentWillUpdate: (props,state)->
		if @props.width != props.width || @props.height != props.height
			state.is_resizing = true




	componentDidUpdate: (prev_props,prev_state)->
		@calculateDim()
		@state.is_resizing = false


		if @props.width != prev_props.width || @props.height != prev_props.height
			@buildTileGrid() #rebuild everything
			return @forceUpdate()

		if prev_props.item_count != @props.item_count
			if @props.item_count > props.item_count
				@calculateGridObjects(@props.item_count,prev_props.item_count) #append items
				return @forceUpdate()
			else
				@buildTileGrid() #rebuild everything
				return @forceUpdate()
		



	getStartYFromScroll: ->
		if @props.vert
			s_y = (@_base.scrollTop / @state.dim_length) - (@_base.clientHeight * @state.scroll_start_beta / @state.dim_length)
		else
			s_y = (@_base.scrollLeft / @state.dim_length) - (@_base.clientWidth * @state.scroll_start_beta / @state.dim_length)

		s_y = Math.floor(s_y)
		if s_y <= 0
			s_y = 0
		if s_y >= @grid.y2
			s_y = @grid.y2

		return s_y



	getEndYFromScroll: ()->
		offset = @getStartYFromScroll()

		if @props.vert
			s_x = offset + @_base.clientHeight / @state.dim_length + @_base.clientHeight * @state.scroll_end_beta / @state.dim_length
		else
			s_x = offset + @_base.clientWidth / @state.dim_length + @_base.clientWidth * @state.scroll_end_beta / @state.dim_length

		s_x = Math.floor(s_x+1)
		if s_x <= 0
			s_x = 0
		if s_x >= @grid.y2
			s_x = @grid.y2

		return s_x


	getRenderItems: ()->
		
	

		start_x = 0
		end_x = @props.size

		if @props.scroll
			start_y = @getStartYFromScroll()
			end_y = @getEndYFromScroll()
		else
			start_y = 0
			end_y = @props.length

		items = []

		@grid.crop start_x,end_x,start_y,end_y,(tile,x,y)=>
			tile_w = (tile.x2 - tile.x1) * @state.dim_size
			tile_h = (tile.y2 - tile.y1) * @state.dim_length
			tile_x = tile.rect.x1 * @state.dim_size
			tile_y = tile.rect.y1 * @state.dim_length

			opts =
				index: tile.item.index
				width: if @props.vert then tile_w else tile_h
				height: if @props.vert then tile_h else tile_w
				x: if @props.vert then tile_x else tile_y
				y: if @props.vert then tile_y else tile_x
			
			items.push @props.renderItem(opts)

		return items

	


	addItem: (i)->
		size = @props.getItemSize(i)
		length = @props.getItemLength(i)

		item = 
			index: i

		if size > @props.size
			size = @props.size
			
		tile = new Tile
			width: size
			height: length
			item: item

		if @props.scroll
			while !@grid.addTile(tile,@grid.full.x2,@grid.x2,@grid.full.y2,@grid.y2)
				@grid.pad(0,0,0,@props.pad_increment)
		else
			added = @grid.addTile(tile,0,@props.size,0,@props.length)



	calculateGridObjects: (item_count,start_count=0)->
		items = [start_count...item_count].map @addItem.bind(@)
	


	buildTileGrid: ()->
		@grid = new TileGrid2
			width: @props.size || 1
			height: @props.length || 1

		@calculateGridObjects(@props.item_count,0)



	calculateDim: ()->
		if @props.vert
			@state.dim_size = @_inner.clientWidth / @props.size
			if @props.length
				if @props.scroll
					@state.dim_length = @_base.clientHeight / @props.length
				else
					@state.dim_length = @_inner.clientHeight / @props.length
			else
				@state.dim_length = @state.dim_size
			
		else
			@state.dim_size = @_inner.clientHeight / @props.size
			
			if @props.length
				if @props.scroll
					@state.dim_length = @_base.clientWidth / @props.length
				else
					@state.dim_length = @_inner.clientWidth / @props.length
			else
				@state.dim_length = @state.dim_size
			
	

	onScroll: (e)=>
		offset = e.target.scrollTop || e.target.scrollLeft
		if Math.abs(offset - @state.p_offset) > @state.dim_length
			@state.p_offset = offset
			@forceUpdate()



	gridRef: (el)=>
		@_base = el
		if @_base
			@calculateDim()
			@buildTileGrid()
			@forceUpdate()


	
	innerRef: (e)=>
		@_inner = e		



	render: ->
		
		max_size = '100%'
		max_length = '100%'
		if @grid && @props.scroll
			max_length = (@grid.y2 * @state.dim_length) || 0

		createElement 'div',
			ref: @gridRef
			onScroll: @props.scroll && @onScroll || null
			style:
				visibility: @state.is_resizing && 'hidden'
			className: 're-tile-grid ' + (@props.vert && 're-tile-grid-vert' || '')
			createElement 'div',
				className: 're-tile-grid-inner'
				ref: @innerRef
				style:
					width: if @props.vert then max_size else max_length
					height: if @props.vert then max_length else max_size
				
				@_base && @getRenderItems() || null


TileGrid.defaultProps =
	pad_increment: 1
	length: 0
	size: 6
	vert: yes
	scroll: yes
module.exports = TileGrid

