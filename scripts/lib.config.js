var webpack = require("webpack");
var path = require("path");
var cfg = {
	devtool: 'source-map',
	module: {
		rules: [
			{ test: /\.coffee$/, use: "coffee-loader"},
			{ test: /\.(xml|html|txt|md|glsl|svg)$/, loader: "raw-loader" },
			{ test: /\.(less)$/, exclude: /^(https?:)?\/\//,use: ['style-loader',{loader:'css-loader',options: {
			    modules: true,
			    // importLoaders: 1,
			     localIdentName: 'lui-[local]'//localIdentName: 'lui-[hash:base64:5]'
			  }},{
			  	loader:'less-loader',
			  	options:{
			  		modifyVars:{"dim":process.env.DIM+"px"}
			  	}

			  }] },
			{ test: /\.(css)$/, exclude: /^(https?:)?\/\//, use: ['style-loader','css-loader'] },
			{ test: /\.(woff|woff2|eot|ttf|png)$/,loader: 'url-loader?limit=65000' }
		]
	},
	entry: {
		index: "./components/index.coffee",
	},
	resolve: {
		extensions: [ '.js', '.coffee' ]
	},
	externals: ["re-slide","react","react-dom","classnames","color"],
	output: {
		path: path.join(__dirname,'..','/dist'),
		publicPath: '/',
		filename: process.env.LIBNAME+".js",
		libraryTarget: 'commonjs2'
	}
}
module.exports = cfg;