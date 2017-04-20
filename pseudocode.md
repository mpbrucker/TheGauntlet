## The Gauntlet Pseudocode

1. Convert scan data to Cartesian coordinates
2. For *n* number of trials:
  * Pick two points randomly
  * Find a line that intersects both
  * Subtract the y-intercept from all points
  * Find unit vector perpendicular to line
  * Project points onto unit vector
  * Find "inliers" and "outliers" based on arbitrary limit
  * Count number of inliers
  * If the number of inliers is > the previous max number of inliers, we have a new best line
3. Create LSRL from points of best line
