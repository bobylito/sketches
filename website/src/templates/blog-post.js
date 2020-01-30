import React from "react"
import { graphql } from "gatsby"
import { PrismLight as SyntaxHighlighter } from "react-syntax-highlighter"
import processing from "react-syntax-highlighter/dist/esm/languages/prism/processing"
import { tomorrow } from "react-syntax-highlighter/dist/esm/styles/prism"

import Layout from "../components/layout"
import SEO from "../components/seo"

SyntaxHighlighter.registerLanguage("processing", processing)

const SketchPost = props => {
  const code = props.data.src.childRawCode.content
  const video = props.data.video.publicURL
  const siteTitle = props.data.site.siteMetadata.title
  const context = props.pageContext

  return (
    <Layout location={props.location} title={siteTitle}>
      <SEO title={context.name} />
      <article>
        <header>
          <h1
            style={{
              marginBottom: 0,
            }}
          >
            {context.name}
          </h1>
        </header>
        <video autoPlay loop width="500">
          <source src={video} type="video/mp4" />
          Sorry, your browser doesn't support embedded videos.
        </video>
        <SyntaxHighlighter language="processing" style={tomorrow}>
          {code}
        </SyntaxHighlighter>
      </article>
    </Layout>
  )
}

export default SketchPost

export const pageQuery = graphql`
  query filesForSketches($nameRegex: String!) {
    site {
      siteMetadata {
        title
      }
    }
    src: file(dir: { regex: $nameRegex }, extension: { eq: "pde" }) {
      publicURL
      childRawCode {
        content
      }
    }
    video: file(dir: { regex: $nameRegex }, extension: { eq: "mp4" }) {
      publicURL
    }
    screenshots: allFile(
      filter: { dir: { regex: $nameRegex }, extension: { eq: "png" } }
    ) {
      edges {
        node {
          publicURL
        }
      }
    }
  }
`
