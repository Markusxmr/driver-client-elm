var path = require("path");
var webpack = require("webpack");
var merge = require("webpack-merge");
var HtmlWebpackPlugin = require("html-webpack-plugin");
var autoprefixer = require("autoprefixer");
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
var entryPath = path.join(__dirname, "src/js/index.js");
var outputPath = path.join(__dirname, "dist");

// determine build env
var TARGET_ENV =
  process.env.npm_lifecycle_event === "build" ? "production" : "development";
var outputFilename =
  TARGET_ENV === "production" ? "[name]-[hash].js" : "[name].js";

// common webpack config
var commonConfig = {
  output: {
    path: outputPath,
    filename: `static/js/${outputFilename}`,
    publicPath: "/"
  },

  plugins: [
    new CopyWebpackPlugin([
      {
        from: "assets/",
        to: "static/"
      }
    ]),
    new HtmlWebpackPlugin({
      template: "src/js/index.ejs",
      inject: "body",
      filename: "index.html"
    })
  ],

  resolve: {
    extensions: [".js", ".elm"]
  },

  module: {
    rules: [
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: "file-loader?name=[name].[ext]"
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            // env: automatically determines the Babel plugins you need based on your supported environments
            presets: ["env"]
          }
        }
      },
      {
        test: /\.scss$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ["style-loader", "css-loader", "sass-loader"]
      },
      {
        test: /\.css$/,
        exclude: [/elm-stuff/, /node_modules/],
        loaders: ["style-loader", "css-loader"]
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "url-loader",
        options: {
          limit: 10000,
          mimetype: "application/font-woff"
        }
      },
      {
        test: /\.(eot|ttf|woff|woff2|svg)$/,
        use: "file-loader"
      }
    ]
  }
};

// additional webpack settings for local env (when invoked by "npm start")
if (TARGET_ENV === "development") {
  console.log("Serving locally...");

  module.exports = merge(commonConfig, {
    entry: ["webpack-dev-server/client?http://0.0.0.0:8080", entryPath],

    plugins: [
      // Suggested for hot-loading
      new webpack.NamedModulesPlugin(),
      // Prevents compilation errors causing the hot loader to lose state
      new webpack.NoEmitOnErrorsPlugin()
    ],

    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: ["elm-hot-loader", "elm-webpack-loader"]
        }
      ]
    },
    devServer: {
      // serve index.html in place of 404 responses
      inline: true,
      historyApiFallback: true,
      contentBase: "./src"
    }
  });
}

// additional webpack settings for prod env (when invoked via "npm run build")
if (TARGET_ENV === "production") {
  console.log("Building for prod...");

  module.exports = merge(commonConfig, {
    entry: entryPath,

    plugins: [
      new webpack.optimize.OccurrenceOrderPlugin(),

      new ExtractTextPlugin("js/styles/[name]-[hash].css"),

      new webpack.optimize.UglifyJsPlugin()
    ],

    module: {
      rules: [
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use: "elm-webpack-loader"
        }
      ]
    }
  });
}
