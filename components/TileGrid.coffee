{createElement,Component} = require 'react'
require './TileGrid.less'

{TileGrid,Tile,Rect} = require 'tile-grid-util'
TileGrid2 = TileGrid



class TileGrid extends Component
	constructor: (props)->
		super(props)
		@state = 
			p_offset: 0
			scroll_start_beta: .5
			scroll_end_beta: 1



	componentWillUpdate: (props,state)->

		if @props.width != props.width || @props.height != props.height
			@buildTileGrid(props.width,props.height,props.item_count) #rebuild everything
			return

		if props.item_count != @props.item_count
			if props.item_count > @props.item_count
				@calculateGridObjects(props.item_count,@props.item_count) #append items
			else
				@buildTileGrid(props.width,props.height,props.item_count) #rebuild everything


	getStartYFromScroll: (dim,vert)->
		if vert
			s_y = (@_base.scrollTop / dim) - (@_base.clientHeight * @state.scroll_start_beta / dim)
		else
			s_y = (@_base.scrollLeft / dim) - (@_base.clientWidth * @state.scroll_start_beta / dim)

		s_y = Math.floor(s_y)
		if s_y <= 0
			s_y = 0
		if s_y >= @grid.y2
			s_y = @grid.y2

		return s_y


	getEndYFromScroll: (dim,vert)->
		offset = @getStartYFromScroll(dim,vert)

		if vert
			s_x = offset + @_base.clientHeight / dim + @_base.clientHeight * @state.scroll_end_beta / dim
		else
			s_x = offset + @_base.clientWidth / dim + @_base.clientWidth * @state.scroll_end_beta / dim

		s_x = Math.floor(s_x+1)
		if s_x <= 0
			s_x = 0
		if s_x >= @grid.y2
			s_x = @grid.y2

		return s_x


	getRenderItems: ()->
		
		dim = @calculateDim()
		vert = @isVert()
		

		start_x = 0
		
		end_x = @props.width

		if vert
			if @props.height > 0
				start_y = 0
				end_y = @props.height
			else
				start_y = @getStartYFromScroll(dim,vert)
				end_y = @getEndYFromScroll(dim,vert)
		else
			if @props.width > 0
				start_y = 0
				end_y = @props.width
			else
				start_y = @getStartYFromScroll(dim,vert)
				end_y = @getEndYFromScroll(dim,vert)

		items = []

		# log 'get render items',start_y,end_y,start_x,end_x

		@grid.crop start_x,end_x,start_y,end_y,(tile,x,y)=>
			tile_w = (tile.x2 - tile.x1) * dim
			tile_h = (tile.y2 - tile.y1) * dim
			tile_x = tile.rect.x1 * dim
			tile_y = tile.rect.y1 * dim
			opts =
				index: tile.item.index
				width: if vert then tile_w else tile_h
				height: if vert then tile_h else tile_w
				x: if vert then tile_x else tile_y
				y: if vert then tile_y else tile_x
			items.push @props.renderItem(opts)

		return items



	isVert: ()->
		if @props.width > 0 && @props.height < 0
			return true
		return false



	buildTileGrid: (width,height,item_count)->
		@grid = new TileGrid2
			width: width > 0 && width || 1
			height: height > 0 && height || 1

		@calculateGridObjects(item_count)


	
	calculateDim: ()->
		if @isVert()
			dim = @_base.clientWidth / @props.width
		else
			dim = @_base.clientHeight / @props.height

		if !dim
			throw new Error "invalid dim ( w:#{@props.width} h:#{@props.height} )"

		return dim



	addItem: (vert,dim,i)->
		# log 'add item',i
		w = @props.getItemWidth(i)
		h = @props.getItemHeight(i)

		
		full_x = @grid.full.x2

		item = 
			index: i
			
		tile = new Tile
			width: w
			height: h
			item: item

		while !@grid.addTile(tile,@grid.full.x2,@grid.x2,@grid.full.y2,@grid.y2)
			@grid.pad(0,0,0,10)
			


	calculateGridObjects: (item_count,start_count=0)->
		vert = @isVert()
		dim = @calculateDim()
		items = [start_count...item_count].map @addItem.bind(@,vert,dim)



	gridRef: (el)=>
		@_base = el
		if @_base
			
			@buildTileGrid(@props.width,@props.height,@props.item_count)
			@forceUpdate()

	onScroll: (e)=>
		offset = e.target.scrollTop || e.target.scrollLeft
		dim = @calculateDim()
		if Math.abs(offset - @state.p_offset) > dim
			@state.p_offset = offset
			@forceUpdate()
				


	render: ->
		vert = @isVert()

		if @grid
			dim = @calculateDim()
			max_height = @grid.y2 * dim
			max_width = '100%'
			

		createElement 'div',
			ref: @gridRef
			onScroll: @onScroll
			className: 're-tile-grid ' + (vert && 're-tile-grid-vert' || '')
			createElement 'div',
				className: 're-tile-grid-inner'
				style:
					width: if vert then max_width else max_height
					height: if vert then max_height else max_width
				@_base && @getRenderItems() || null


module.exports = TileGrid