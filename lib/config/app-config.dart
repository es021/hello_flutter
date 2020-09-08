import 'dart:math';


const APP_TITLE = "Life Tracker";
const APP_SPLASH_SCREEN_TIME_SECOND = 1;

// icon at assets/icon/icon.png
const quotes = [
  "Train your mind to see\nthe good in every situation.",
  "You will never always be motivated,\nso you must learn to be disciplined",
  "Comparison will kill you.",
  "It's not about 'having' time.\nIt's about making time.",
  "Be the person you want\nto have in your life",
  "It always seems\nimpossible until its done.",
  "Let's go!",
  "Fall in love with\ntaking care of your body.",
  "Three months from now,\nyou will thank yourself.",
];

int randomIndex = (new Random()).nextInt(quotes.length);
var APP_SPLASH_SCREEN_QUOTE = quotes[randomIndex];
