var webpack = require("webpack");
var path = require("path");
define_plugin = new webpack.DefinePlugin({
  DIM: "42"
})
var cfg = {
	devtool: 'source-map',
	module: {
		rules: [
			{ test: /\.coffee$/, use: "coffee-loader"},
			{ test: /\.(xml|html|txt|md|glsl|svg)$/, loader: "raw-loader" },
			{ test: /\.(less)$/, exclude: /^(https?:)?\/\//,use: ['style-loader',{loader:'css-loader',options: {
			    modules: true,
			    localIdentName: 'lui-[local]'
			  }},{
			  	loader:'less-loader',
			  	// options:{
			  	// 	modifyVars:{"dim":"30px"}
			  	// }

			  }] },
			{ test: /\.(css)$/, exclude: /^(https?:)?\/\//, use: ['style-loader','css-loader'] },
			{ test: /\.(woff|woff2|eot|ttf|png)$/,loader: 'url-loader?limit=65000' }
		]
	},

	entry: {
		demo: path.join(__dirname,'..','/demo.coffee')
	},
	resolve: {
		extensions: [ '.js', '.coffee' ]
	},	
	output: {
		path: path.join(__dirname,'..','/dist'),
		publicPath: '/dist',
		filename: "[name].js"
	},
	devServer: {
		port: 3234,
		disableHostCheck: true
		// host: 'localhost'
	}
	// plugins: [define_plugin]
}
module.exports = cfg;