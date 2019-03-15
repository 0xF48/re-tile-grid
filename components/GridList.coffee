{createElement,Component} = require 'react'
require './GridList.less'
{TileGrid,Tile,Rect} = require 'tile-grid-util'

class GridList extends Component
	constructor: (props)->
		super(props)
		@state = 
			grid_items: []



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
			return @_base.scrollTop / dim
		else
			return @_base.scrollLeft / dim


	getEndYFromScroll: (dim,vert)->
		offset = @getStartYFromScroll(dim,vert)

		if vert
			return offset + @_base.clientHeight / dim
		else
			return offset + @_base.clientWidth / dim



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

		@grid.clip start_x,end_x,start_y,end_y,(tile)=>
			opts =
				key: tile.item.key
				width: vert && (tile.width * dim) || (tile.height * dim)
				height: vert && (tile.height * dim) || (tile.width * dim)
				x: vert && (tile.x1 * dim) || (tile.y1 * dim)
				y: vert && (tile.y1 * dim) || (tile.x1 * dim)
			items.push @props.renderItem(opts)

		return items



	isVert: ()->
		if @props.width > 0 && @props.height < 0
			return true
		return false



	buildTileGrid: (width,height,item_count)->
		@grid = new TileGrid
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
		w = @props.getItemWidth(i)
		h = @props.getItemHeight(i)
		
		full_x = @_grid.full.x2

		item = 
			key: 'i'+i
			
		tile = new Tile
			width: w
			height: h
			item: item

		while !@grid.addTile(tile,@_grid.full.x2,@_grid.x2,@_grid.full.y2,@_grid.y2)
			@grid.pad(0,0,0,10)
			


	calculateGridObjects: (item_count,start_count=0)->
		vert = @isVert()
		dim = @calculateDim()
		items = [start_count...item_count].map @addItem.bind(@,vert,dim,i)



	gridRef: (el)=>
		@_base = el
		if @_base
			@buildTileGrid(@props.width,@props.height,@props.item_count)
			@forceUpdate()



	render: ->
		h 'div',
			ref: gridRef
			clasName: 're-grid-list ' + (@isVert() && 're-grid-list-vert' || '')
			@_base && @getRenderItems() || null


module.exports = GridList