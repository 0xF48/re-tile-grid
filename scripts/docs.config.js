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
		docs: path.join(__dirname,'..','/docs/docs.coffee')
	},
	resolve: {
		extensions: [ '.js', '.coffee' ]
	},	
	output: {
		path: path.join(__dirname,'..','/builds'),
		publicPath: '/builds',
		filename: "[name].js"
	},
	// plugins: plugins,
	devServer: {
		port: 7373,
		disableHostCheck: true,
		host: 'localhost'
	}
}
module.exports = cfg;