import React from "react"
import classnames from "classnames"

const Link = ({ children, className, ...otherProps }) => (
  <Link className={classnames("underline", className)} {...otherProps}>
    {children}
  </Link>
)

export default Link
