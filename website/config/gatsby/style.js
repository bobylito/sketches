module.exports = [
  `gatsby-plugin-postcss`,
  {
    resolve: `gatsby-plugin-google-fonts`,
    options: {
      fonts: [`Muli:800`, "Open+Sans:400,600"],
      display: "swap",
    },
  },
  {
    resolve: `gatsby-plugin-purgecss`,
    options: {
      printRejected: true, // Print removed selectors and processed file names
      // develop: true, // Enable while using `gatsby develop`
      tailwind: true, // Enable tailwindcss support
      // whitelist: ['whitelist'], // Don't remove this selector
      // ignore: ['/ignored.css', 'prismjs/', 'docsearch.js/'], // Ignore files/folders
      // purgeOnly : ['components/', '/main.css', 'bootstrap/'], // Purge only these files/folders
    },
  },
]
