https://api.flutter.dev/flutter/cupertino/CupertinoIcons-class.html
https://mobx.netlify.app/getting-started


SELECT category,
SUM(CASE WHEN  amount_custom IS NULL THEN amount ELSE amount_custom END) as total
FROM expense
WHERE month=9 AND year=2020
GROUP BY category