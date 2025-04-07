const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
    theme: {
      extend: {
        fontFamily: {
          'sans': ['Artegra Sans', ...defaultTheme.fontFamily.sans],
        },
      },
    },
  }
