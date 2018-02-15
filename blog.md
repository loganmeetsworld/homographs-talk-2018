# Homographs, Attack!

Homograph attacks have been a concept in security since the late 1990s so why do we find ourselves still talking about them today? In this post, I plan to explore the history of homograph attacks, and why, like many of the internet's path dependency problems, it seems like they just won't ever go away.

## Origins of my Interest

I first got interested in homograph attacks a few months back when I was working through tickets for Kickstarter's [Hackerone](https://hackerone.com) program. HackerOne is a "bug bounty program", or, an invitation that hackers and security researchers find vulnerabilities in our site in exchange for money.

When I was looking through the tickets, one caught my attention. It wasn't a particularly high risk vulnerability, but I didn't understand a lot of words in the ticket, so of course I was interested. The hacker was concerned about Kickstarter's profile pages. We often get reports about our profile and project pages.

![Example of Kickstarter's Profile Page](https://imgur.com/Yr3KizX)

The issue is that whenever you are in the position to "host" someone on your site, you are going to have to think about the ways they'll abuse that legitimacy you give them. Our hacker was specifically concerned about a field that allows our users to add user-urls or "websites" to their profile. 

![Example of Kickstarter's Profile Page Websites](https://imgur.com/6EpiaXz)

They thought this section could be used in a homograph attack. To which I was like, what the heck is a homograph attack? And that question lead me down a rabbit hole of international internet governance, handfuls of RFCs, and a decades-old debate about the global nature of the internet.

## Internet Corporation for Names and Numbers (ICANN)

We have to start with ICANN, the main international internet body in charge in this story. Along with performing the technical maintenance of the DNS root zone registries and maintain the namespaces of the Internet, ICANN makes all the rules about what can and cannot be a domain name.

For example, say you go to Namecheap to register "loganisthemostawesome.com". Namecheap uses the [“extensible provisioning protocol”](https://en.wikipedia.org/wiki/Extensible_Provisioning_Protocol) to verify your name with Verisign. Verisign is the organization that manages the registry for the “.com” gTLD. Versign checks the ICANN rules and regulations for your registration attempt, tells Namecheap the result, and Namecheap tells me if I can register "loganisthemostawesome.com". Spoilers: I can!

This is great. But I primarily speak English and I use ASCII for all my awesome businesses on the internet. What happens to all those other languages that can’t be expressed in a script compatible with ASCII?

### Version 1 of Internationalized Domain Names

That’s the question ICANN was asking themselves when they [proposed and implemented IDNs](https://www.icann.org/resources/pages/idn-guidelines-2003-06-20-en) as a standard protocol for domain names in the late 90s. They wanted a more global internet so they opened up domains to a variety of unicode represented scripts.

What's a script? A script is a collection of letters/signs for a single system. For example, Latin is a script that supports many languages, whereas a script like Kanji is one of the scripts supporting the Japanese language. Scripts can support many languages, and languages can be made of multiple scripts. ICANN keeps tables of all unicode character it associates with any given script.

This is even better now! Through IDNs, ICANN has given us the ability to express internet communities across many scripts. However, there was one important requirement. [ICANN’s Domain Name System](https://en.wikipedia.org/wiki/Domain_Name_System), which performs a lookup service to translate user-friendly names into network addresses for locating Internet resources, is restricted in practice to the use of ASCII characters.

### Punycode

Thus ICANN turned to Punycode. Punycode is just puny unicode. Bootstring is the algorithm  that translates names written in language-native scripts (unicode) into an ASCII text representation that is compatible with the Domain Name System (punycode).

For example, take this fictional domain name (because we still can't have emojis in gTLDs 😭):

> hi👋friends💖🗣.com

If you put this in your browser, the real lookup against the Domain Name System would have to use the punycode equivalent:

> `xn--hifriends-mq85h1xad5j.com`

So, problems solved. We have a way to use domain names in unicode scripts that represent the full global reach of the internet and can start handing out IDNs. Great! What could go wrong?

## Homographs

Well, things aren’t always as they seem. And this is where homographs and homoglyphs come in.

![Gif of Puppy Seeing Itself in the Mirror](https://i.imgur.com/16szzeE.gifv)

Much like this puppy sees copy-pups of itself, a homograph refers to multiple things that look or seem the same, but have different meanings. We have many of these in English, for example “lead” could refer to the metallic substances or the past tense of “to lead.”

The problem when it comes to IDNs is that homoglyphs exist between scripts as well, with many of the Latin letters having copies in other scripts, like Greek or Cyrillic.

Example of lookalikes from homoglyphs.net:

![Homoglyphs.net Image of Example Homoglyphs](https://imgur.com/MYkUwMw)

Let's look at an example of a domain name.

> washingtonpost.com

vs

> wаshingtonpost.com

Can you tell the difference? Well, let's translate both of these to purely ASCII:

> washingtonpost.com

vs

> `xn--wshingtonpost-w1k.com`

Uh oh, these definitely aren't the same. However, user-agents would make them appear the same in a browser, in order to make the punycode user-friendly.

This presented ICANN with a big problem. You can clearly see how these may be used in phishing attacks when user-agents interpret both Washington Post's as homographs, making them look exactly same. So what was ICANN to do?

## Internationalized Domain Names Version 2 & 3

By 2005, ICANN had figured out a solution. They told gTLD registrars they had to restrict mix scripts. Every single registered domain had to have a "label" on it to indicate the single pure script that the domain name would use to support it's language. Today, if you went and tried to register our copy-cat Washington Post at `xn--wshingtonpost-w1k.com`, you would get an error. Note: There were a few exceptions made, however, for languages that need to be mixed script, like Japanese.

Problem fixed, right? Well, while mixed scripts are not allowed, pure scripts are still perfectly fine according to ICANN's guidelines. Thus, we still have a problem. What about pure scripts in Cyrillic or Greek alphabets that look like the Latin characters? How many of those could there be?

## Proof of Concept

![Gif of POC](https://giphy.com/gifs/YFH1Nz1PcHXb9Ym5xU)

Well, when I was talking to my friend [@frewsxcv](https://github.com/frewsxcv) about homograph attacks, he had the great idea to make a script to find susceptible urls for the attack. So I made a [homograph attack detector](https://github.com/loganmeetsworld/homographs-talk/tree/master/ha-finder) that:

* Takes the top 1 million websites
* For each domain, checks if letters in each are confusable with latin or decimal
* Checks to see if the punycode url for that domain is registered through a WHOIS lookup
* Returns all the available domains we could register

A lot of the URLs are a little off looking with the Cyrillic (also a lot of the top 1 million websites are porn), but we found some interesting ones you could register.

For example, here's my personal favorite. In both Firefox and Chrome, visit:

> https://раураӏ.com/

Pretty cool! In Firefox, it totally looks like the official PayPal in the address bar! However, in Chrome, it resolves to punycode. Why is that? 🤔

## User-Agents & Their Internationalized Domain Names Display Algorithms

It is because Chrome and Mozilla use different Internalized Domain Name Display Algorithms. [Chrome's algorithm](https://www.chromium.org/developers/design-documents/idn-in-google-chrome) is much stricter and more complex than Mozilla's, and includes special logic to protect against homograph attacks. Chrome checks to see if the domain name is on a gTLD and all the letters are confusable Cyrillic, then it shows punycode in the browser rather than the unicode characters. Chrome only changed this recently because of [Xudong Zheng’s 2017 report](https://www.xudongz.com/blog/2017/idn-phishing/).

Firefox, on the other hand, still shows the full URL in its intended script, even if it's confusable with Latin characters. I want to point out that Firefox allows you to change your settings to _always_ show punycode in the Browser, but if you often use sites that aren't ASCII domains, this can be pretty inaccessible.

## So, what's next?

So what, now, is our responsibility as application developers and maintainers if we think someone might use our site to phish people using a homograph? I can see a couple paths forward:

1. Advocate to Mozilla and other user-agents to make sure to change their algorithms to protect users.
1. Advocate that ICANN changes its rules around registering domains with Latin confusable characters.
1. Implement our own display algorithms. This is what we ended up doing at Kickstarter. We used Google's open-source algorithm and show a warning if it's possible that the url shown on the page is a homograph for another url.
1. Finally, we could just register these domains like [@frewsxcv](https://github.com/frewsxcv) and I did with PayPal so that they aren't able to be used maliciously. Possibly, if we are part of an organization with a susceptible domain, we should just register it.

To summarize, this is a hard problem! That's why it's been around for two decades. And fundamentally what I find so interesting about the issues surfaced by this attack. I personally think ICANN did the right thing in allowing IDNs in various scripts. The internet should be more accessible to all.

I like Chrome's statement in support of their display algorithm, however, which nicely summarizes the tradeoffs as play: 

> We want to prevent confusion, while ensuring that users across languages have a great experience in Chrome. Displaying either punycode or a visible security warning on too wide of a set of URLs would hurt web usability for people around the world.

The internet is full of these tradeoffs around accessibility versus security. As users and maintainers of this wonderful place, I find conversations like these to be one of the best parts of building our world together.

Now, we just gotta get some emoji support.

Thanks for reading! 🌍💖🎉🙌🌏

## Resources

### Background

* [Wikipedia on Homograph Attacks](https://en.wikipedia.org/wiki/IDN_homograph_attack)
* [Wikipedia on IDNs](https://en.wikipedia.org/wiki/Internationalized_domain_name)
* [Plagiarism Detection in Texts Obfuscated with Homoglyphs](http://eprints.whiterose.ac.uk/112665/1/paper_247v2.pdf)
* [A Collective Intelligence Approach to Detecting IDN Phishing by Shian-Shyong Tseng, Ai-Chin Lu, Ching-Heng Ku, and Guang-Gang Geng](https://kaigi.org/jsai/webprogram/2013/pdf/960.pdf)
* [Exposing Homograph Obfuscation Intentions by Coloring Unicode Strings by Liu Wenyin, Anthony Y. Fu, and Xiaotie Deng](https://slides.tips/exposing-homograph-obfuscation-intentions-by-coloring-unicode-strings.html)
* [Phishing with Unicode Domains by Xudong Zheng](https://www.xudongz.com/blog/2017/idn-phishing/)
* [The Homograph Attack by Evgeniy Gabrilovich and Alex Gontmakher](http://evgeniy.gabrilovich.com/publications/papers/homograph_full.pdf) NOTE: The original paper!
* [Cutting through the Confusion: A Measurement Study of Homograph Attacks by Tobias Holgers, David E. Watson, and Steven D. Gribble](http://static.usenix.org/events/usenix06/tech/full_papers/holgers/holgers_html/)
* [Assessment of Internationalised Domain Name Homograph Attack Mitigation by Peter Hannay and Christopher Bolan](http://ro.ecu.edu.au/cgi/viewcontent.cgi?article=1010&context=ism)
* [Multilingual web sites: Internationalized Domain Name homograph attacks by Johnny Al Helou and Scott Tilley](http://ieeexplore.ieee.org/abstract/document/5623562/?reload=true)
* [IDN Homograph Attack Potential Impact Analysis by @jsidrach](https://github.com/jsidrach/idn-homograph-attack)

### Browser policies

* [Chrome's IDN Display Algorithm](https://www.chromium.org/developers/design-documents/idn-in-google-chrome)
* [Mozilla's IDN Display Algorithm](https://wiki.mozilla.org/IDN_Display_Algorithm)
* [UTC Mixed Script Detection Security Mechanisms](https://www.unicode.org/reports/tr39/#Mixed_Script_Detection)
* [Chrome's IDN Spoof Checker](https://cs.chromium.org/chromium/src/components/url_formatter/idn_spoof_checker.cc)
* [Bugzilla Open Bug on IDNs](https://bugzilla.mozilla.org/show_bug.cgi?id=1332714#c79)

### Tools

* [Homograph Attack Generator for Mixed Scripts](https://github.com/UndeadSec/EvilURL) NOTE: It is no longer possible to register mixed script domain names.
* [Homograph Attack Finder for Pure Cyrillic Scripts](https://github.com/frewsxcv/homograph-attack-finder/)
* [Homograph Attack Finder + WHOIS lookup for Pure Cyrillic Scripts](https://github.com/loganmeetsworld/homographs-talk/tree/master/ha-finder)
* [Homoglyph Dictionary](http://homoglyphs.net/)
* [Puncode converter](https://www.punycoder.com)

### ICANN CFPs and Guidelines

* [2005 IDN Version 2.0 Guidelines](https://www.icann.org/resources/unthemed-pages/idn-guidelines-2005-11-14-en)
* [ICANN 2005 RFC Announcement for Version 2.0 of IDN Guidelines](https://www.icann.org/news/announcement-2005-02-23-en)
* [IDNA2008 Version 2.2 draft](https://www.icann.org/en/system/files/files/idn-guidelines-26apr07-en.pdf)
* [2011 IDN Version 3.0 Guidelines](https://www.icann.org/resources/pages/idn-guidelines-2011-09-02-en)

### ICANN, Verisign, and the Domain Registration Process

* [Wikipedia for TLD](https://en.wikipedia.org/wiki/List_of_Internet_top-level_domains). Each TLD has its own Registry that manages it and defines its IDN rules.
* [Wikipedia for Domain Name Registry](https://en.wikipedia.org/wiki/Domain_name_registry), like Verisign
* [Wikipedia for Domain Name Registrar](https://en.wikipedia.org/wiki/Domain_name_registrar), like Namecheap, Godaddy, or Gandi.net
* [ICANN Accreditation and Verisign Certification](https://www.verisign.com/en_US/channel-resources/become-a-registrar/verisign-domain-registrar/index.xhtml) for distributing .com domains
* [Wikipedia for the Extensible Provisioning Protocol](https://en.wikipedia.org/wiki/Extensible_Provisioning_Protocol), which is used when a user on a registry requests a .com domain. The registry uses the EPP protocol to communicate with verisign to register the domain.
* [Verisign's IDN Policy](https://www.verisign.com/en_US/channel-resources/domain-registry-products/idn/idn-policy/registration-rules/index.xhtml). Verisign requires you specify a three letter language tag associated with the domain upon registration. this tag determines which character scripts you can use in the domain. presumably the language tag for https://аррӏе.com/ (cyrillic) is 'RUS' or 'UKR'.
* [PIR, manager of .org TLDs, IDN rules](https://pir.org/products/org-domain/org-idns/)

### Misc Security related to Domains

* [Extended Validation Is Broken by @iangcarroll](https://stripe.ian.sh/)

### Homograph Major Site Copy-cat Examples

* http://аоӏ.com/
* https://раураӏ.com/
* https://аррӏе.com/
* http://www.спп.com/
