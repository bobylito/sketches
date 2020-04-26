import React from "react"
import { Link, graphql } from "gatsby"
import Img from "gatsby-image"

import Layout from "../components/layout"
import SEO from "../components/seo"

import { H1, H2, H3, P } from "../components/typography"

const Index = props => {
  const { data } = props
  const siteTitle = data.site.siteMetadata.title
  const sketches = data.allDirectory.edges
  const screenshots = data.screenshots.edges.reduce((shots, edge) => {
    const { relativeDirectory, childImageSharp } = edge.node
    shots[relativeDirectory] = childImageSharp
    return shots
  }, {})

  return (
    <Layout location={props.location} title={siteTitle}>
      <SEO title="All posts" />
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
        {sketches.map(({ node }) => {
          const { name: title } = node
          return (
            <article key={node.name} className="w-full">
              <header>
                <H2 className="pt-4">
                  <Link
                    style={{ boxShadow: `none` }}
                    to={`sketches/${node.name}`}
                  >
                    {node.name}
                    {screenshots[title] && (
                      <Img fluid={screenshots[title].fluid} />
                    )}
                  </Link>
                </H2>
              </header>
            </article>
          )
        })}
      </div>
    </Layout>
  )
}

export default Index

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        title
      }
    }
    allDirectory(
      filter: { name: { regex: "/day[0-9]+/" } }
      sort: { fields: name, order: DESC }
    ) {
      edges {
        node {
          name
          dir
          relativePath
        }
      }
    }
    screenshots: allFile(
      filter: {
        dir: { regex: "/day[0-9]+/" }
        name: { eq: "screenshot-2" }
        extension: { eq: "png" }
      }
    ) {
      edges {
        node {
          relativeDirectory
          childImageSharp {
            fluid(maxWidth: 500) {
              ...GatsbyImageSharpFluid
            }
          }
        }
      }
    }
  }
`
