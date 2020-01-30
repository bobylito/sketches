import React from "react"
import classnames from "classnames"

const P = ({ children, className, ...otherProps }) => (
  <p className={classnames("font-body", className)} {...otherProps}>
    {children}
  </p>
)

export default P
