import React from "react"
import { Link as GatsbyLink } from "gatsby"

import "../style/index.css"

import { H1, H3, P } from "./typography"

class Layout extends React.Component {
  render() {
    const { location, title, children } = this.props
    const rootPath = `${__PATH_PREFIX__}/`
    const header =
      location.pathname === rootPath ? (
        <H1>
          <GatsbyLink to={`/`}>{title}</GatsbyLink>
        </H1>
      ) : (
        <H3>
          <GatsbyLink to={`/`}>{title}</GatsbyLink>
        </H3>
      )

    return (
      <div className="mx-auto">
        <header className="px-2">{header}</header>
        <main className="px-2">{children}</main>
        <footer className="p-2 mt-4 text-gray-500 bg-black">
          <P>
            © Alexandre Valsamou-Stanislawski 2019-{new Date().getFullYear()}
          </P>
          <small>
            Built with
            {` `}
            <a href="https://www.gatsbyjs.org">Gatsby</a>
          </small>
        </footer>
      </div>
    )
  }
}

export default Layout
