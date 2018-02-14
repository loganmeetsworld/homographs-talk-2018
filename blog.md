# TODO WIP

Homograph attacks have been a concept since the late 1990s. So why do we find ourselves still talking about them today? In this post, I plan to explore the history of homographs, and why, like many of the internets path dependent problems, it seems like they just won't ever go away.

## Origins

* Hackerone program
* Websites hosting profiles
* Kickstarter's bug bounty program

## ICANN

Along with performing the technical maintenance of the DNS root zone registries and maintain the namespaces of the Internet, ICANN makes all the rules about what can and cannot be a domain name.

So say you go to Namecheap to register loganisawesome.com. Namecheap uses the “extensible provisioning protonol” to verify your name with Verisign which is the organization that manages the registry for the “.com” gTLD. Versign checks the ICANN rules and regulations for your registration attempt, tells Namecheap the result, and Namecheap tells me if I can register loganisawesome.com. 

This is great. But I speak English and I use ASCII for all my awesome business on the internet. What happens to all those other languages that can’t be expressed in a script compatible with ASCII?

### Version 1 of Internationalized Domain Names

That’s the question ICANN was asking themselves when they proposed and implemented IDNs as a standard protocol for domain names in the late 90s. They wanted a more global internet so they opened up domains to a variety of unicode represented scripts.

What's a script? So a script is just a collection of letters/signs for a single system; for example, Latin (supporting many languages) or Kanji (which is just one of the scripts that supports the Japanese language).

However, there was a requirement. ICANN’s Domain Name System, which performs a lookup service to translate user-friendly names into network addresses for locating Internet resources, is restricted in practice to the use of ASCII characters.

### Punycode

Thus ICANN turned to Punycode. This is the protocol for that translates names written in language-native scripts into an ASCII text representation that is compatible with the Domain Name System.

[Punycode example]

So, problems solved. We have a way to use domain names in unicode scripts that represent the full global reach of the internet. Great! What could go wrong?

## Homographs

Well, things aren’t always as they seem. And this is where homographs come in.

A homograph or homoglyph is multiple things that look or seem the same. We have many of these in English, for example “lead” could refer to the metallic substances or the past tense of “to lead.”

The problem is that homoglyphs exist between scripts as well, with many of the Latin letters having copycats in other scripts, like Greek or Cyrillic.

Let's look at an example.

washingtonpost.com
vs
wаshingtonpost.com

Can you tell the difference? Well, let's translate both of these to purely ASCII.

washingtonpost.com
vs
xn--wshingtonpost-w1k.com

Uh oh, these definitely aren't the same. So this presented ICANN with a big problem. You can clearly see how these may be used in phishing attacks when useragents interpret both WashingtonPost's making them look the same. So what was ICANN to do?

## Internationalized Domain Names Version 2 & 3

By 2008, ICANN had figured out a solution. They told gTLD registrars they had to restrict mix scripts. Every single registered domain had to have a "label" on it to indicate the single pure script that the domain name would use to support it's language. So today, if you went and tried to register our copy-cat Washington Post at xn--wshingtonpost-w1k.com, you would get an error.

Problem fixed, right? Well, while mixed scripts are not allowed, pure scripts are perfectly fine. So we still have a problem, what about pure scripts in Cyrillic or Greek alphabets that look like the Latin characters? How many of those could there be?

## Proof of Concept

[Gif of POC]

A co-worker and I had the idea to make a homograph attack detector so we made a script that :

* Takes the top 1million websites
* Checks if letters in each are confusable with latin/decimal
* Checks to see if the punycode url is registered through a WHOIS lookup

A lot of the URLs a little off looking with the Cyrillic (also a lot of the top 1 million websites are porn), but we found some interesting ones you could register.

For example, in Firefox and Chrome, go to 

https://раураӏ.com/

Notice the difference in the Browsers? Why is that?

## User Agents & Their Internationalized Domain Names Display Algorithms

This is because Chrome and Mozilla use different Internalized Domain Name Display Algorithms. [Chrome's algorithm](https://www.chromium.org/developers/design-documents/idn-in-google-chrome) is much stricter and more complex than Mozilla's. Chrome checks to see if the domain name is on a gTLD and all the letters are confusable Cyrillic, then it shows punycode in the browser rather than the unicode characters. Firefox, on the other hand, shows the full URL in its intended script, even if it's confusable with Latin characters. However, I want to point out that Firefox allows you to change your settings to _always_ show punycode in the Browser, but if you often use sites that aren't ASCII domains, this can be pretty inaccessible.

## Who is responsible now then?

So what, now, is our responsibility as application developers. I can see a couple paths forward:

1. Advocate to Firefox and other user-agents to make sure to change their algorithms to protect users.
2. Advocate that ICANN changes it’s rules around registering domains with Latin confusable domains.
3. Implement our own display algorithms, which is what we eneded up doing at Kickstarter. We used Google's open-source algorithm and show a warning if it's possible that the url shown on the page is a homograph for another url.
4. Finally, we could just register these domains like I did with Paypal so that they aren't able to be used maliciously. Possibly, if we are part of an organization with a suseptible domain, we should just register it.

To summarize, this is a hard problem! That's why it's been around for two decades. And fundamentally what I find so interesting about the issues surfaced by this attack. 

Chrome only changed it because of [Xudong Zheng’s 2017 report](https://www.xudongz.com/blog/2017/idn-phishing/).  I like their statement in support of their display algorithm: “We want to prevent confusion, while ensuring that users across languages have a great experience in Chrome. Displaying either punycode or a visible security warning on too wide of a set of URLs would hurt web usability for people around the world.” The internet is full of these tradeoffs around accessibility and this is just one example I found interesting.
