const path = require(`path`)
const { createFilePath } = require(`gatsby-source-filesystem`)

exports.createPages = async ({ graphql, actions }) => {
  const { createPage } = actions

  const blogPost = path.resolve(`./src/templates/blog-post.js`)
  const result = await graphql(
    `
      {
        allDirectory(filter: { name: { regex: "/day[0-9]+/" } }) {
          edges {
            node {
              name
              dir
              relativePath
            }
          }
        }
      }
    `
  )

  if (result.errors) {
    throw result.errors
  }

  // Create blog posts pages.
  const sketchesFolder = result.data.allDirectory.edges

  sketchesFolder.forEach((sketch, index) => {
    createPage({
      path: `sketches/${sketch.node.name}`,
      component: blogPost,
      context: {
        nameRegex: `/${sketch.node.name}/`,
        name: sketch.node.name,
      },
    })
  })
}
