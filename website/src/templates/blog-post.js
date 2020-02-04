import React from "react"
import { graphql } from "gatsby"
import { PrismLight as SyntaxHighlighter } from "react-syntax-highlighter"
import processing from "react-syntax-highlighter/dist/esm/languages/prism/processing"
import { tomorrow } from "react-syntax-highlighter/dist/esm/styles/prism"

import Layout from "../components/layout"
import SEO from "../components/seo"
import { H1, H2, P, A } from "../components/typography"
import Video from "../components/video"

SyntaxHighlighter.registerLanguage("processing", processing)

const SketchPost = props => {
  const code = props.data.src.childRawCode.content
  const video = props.data.video.publicURL
  const siteTitle = props.data.site.siteMetadata.title
  const context = props.pageContext
  const screenshot = props.data.screenshot.publicURL

  return (
    <Layout location={props.location} title={siteTitle}>
      <SEO title={context.name} />
      <article>
        <header>
          <H1>{context.name}</H1>
        </header>
        <Video video={video} screenshot={screenshot} />
        <H2>Code</H2>
        <P>
          View on{" "}
          <A
            href={`https://github.com/bobylito/sketches/tree/master/code/${context.name}`}
          >
            github
          </A>
        </P>
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
    screenshot: file(
      dir: { regex: $nameRegex }
      name: { eq: "screenshot-2" }
      extension: { eq: "png" }
    ) {
      publicURL
    }
  }
`
