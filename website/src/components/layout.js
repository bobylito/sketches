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
        <div className="flex flex-col md:flex-row justify-center">
          <H1 className="mb-0 text-sm">
            <GatsbyLink to={`/`}>{title}</GatsbyLink>
          </H1>
          <nav className="text-base md:flex-grow md:text-right md:m-auto">
            <GatsbyLink className="underline mr-1 md:mr-3" to={`/about`}>
              About the project
            </GatsbyLink>
            |
            <a
              className="underline ml-1 md:ml-3"
              href="https://www.instagram.com/bobylito/"
            >
              See on Instagram
            </a>
          </nav>
        </div>
      ) : (
        <H3>
          <GatsbyLink to={`/`}>{title}</GatsbyLink>
        </H3>
      )

    return (
      <div className="mx-auto overflow-hidden">
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
