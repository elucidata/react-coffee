const path = require('path');

module.exports = {
  entry: './src/component.coffee',
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: ['coffee-loader']
      }
    ]
  },
  externals: {
    react: {
      commonjs: 'react',
      commonjs2: 'react',
      amd: 'react',
      root: 'React'
    }
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'react-coffee.js',
    library: 'react-coffee',
    libraryTarget: 'umd'
  }
};
