import React from "react"
import classnames from "classnames"

const H3 = ({ children, className, ...otherProps }) => (
  <h3 className={classnames("font-body text-xl", className)} {...otherProps}>
    {children}
  </h3>
)

export default H3
