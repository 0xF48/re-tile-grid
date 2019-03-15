var webpack = require("webpack");
var path = require("path");


var cfg = {
	devtool: 'source-map',
	module: {
		rules: [
			{ test: /\.coffee$/, use: "coffee-loader"},
			{ test: /\.(xml|html|txt|md|glsl|svg)$/, loader: "raw-loader" },
			{ test: /\.(less)$/, exclude: /^(https?:)?\/\//,use: ['style-loader','css-loader','less-loader'] },
			{ test: /\.(css)$/, exclude: /^(https?:)?\/\//, use: ['style-loader','css-loader'] },
			{ test: /\.(woff|woff2|eot|ttf|png)$/,loader: 'url-loader?limit=65000' }
		]
	},

	entry: {
		'tile-grid': path.join(__dirname,'..','/components/TileGrid.coffee')
	},
	resolve: {
		extensions: [ '.js', '.coffee' ]
	},	
	output: {
		path: path.join(__dirname,'..','/builds'),
		publicPath: '/builds',
		filename: "tile-grid.js"
	},
	externals: ["re-slide","react","react-dom","classnames","color"],
	output: {
		path: path.join(__dirname,'..','/builds'),
		publicPath: '/',
		filename: "tile-grid.js",
		libraryTarget: 'commonjs2'
	}
}

module.exports = cfg