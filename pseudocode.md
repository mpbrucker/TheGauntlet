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
4. Find endpoints of line:
  * Standardize inlier points
  * Project all inlier points onto LSRL
  * Take the most extreme points that aren't outliers (i.e. there isn't a significant gap between the point and the next-closest point)
  * Those points' projections onto the LSRL are the endpoints
5. Repeat steps 2 - 4 for a varying number of lines (1 - j)
  * Find each line using steps 2 - 4
  * Get the "robust" set of inlier points using step 4
  * remove all inlier points from dataset
  * Repeat with the next line
  * The number of lines that gives the highest total number of "robust inliers" is the correct number of lines
