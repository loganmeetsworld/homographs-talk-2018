# Resources

## Research

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

## Browser policies

* [Chrome's IDN Display Algorithm](https://www.chromium.org/developers/design-documents/idn-in-google-chrome)
* [Mozilla's IDN Display Algorithm](https://wiki.mozilla.org/IDN_Display_Algorithm)
* [UTC Mixed Script Detection Security Mechanisms](https://www.unicode.org/reports/tr39/#Mixed_Script_Detection)
* [Chrome's IDN Spoof Checker](https://cs.chromium.org/chromium/src/components/url_formatter/idn_spoof_checker.cc)
* [Bugzilla Open Bug on IDNs](https://bugzilla.mozilla.org/show_bug.cgi?id=1332714#c79)

## Tools

* [Homograph Attack Generator for Mixed Scripts](https://github.com/UndeadSec/EvilURL) NOTE: It is no longer possible to register mixed script domain names.
* [Homograph Attack Finder for Pure Cyrillic Scripts](https://github.com/frewsxcv/homograph-attack-finder/)
* [Homograph Attack Finder + WHOIS lookup for Pure Cyrillic Scripts](https://github.com/loganmeetsworld/homographs-talk/tree/master/ha-finder)
* [Homoglyph Dictionary](http://homoglyphs.net/)
* [Puncode converter](https://www.punycoder.com)

## ICANN CFPs and Guidelines

* [2005 IDN Version 2.0 Guidelines](https://www.icann.org/resources/unthemed-pages/idn-guidelines-2005-11-14-en)
* [ICANN 2005 RFC Announcment for Version 2.0 of IDN Guidelines](https://www.icann.org/news/announcement-2005-02-23-en)
* [IDNA2008 Version 2.2 draft](https://www.icann.org/en/system/files/files/idn-guidelines-26apr07-en.pdf)
* [2011 IDN Version 3.0 Guidelines](https://www.icann.org/resources/pages/idn-guidelines-2011-09-02-en)

## ICANN, Verisign, and the Domain Registration Process

* [Wikipedia for TLD](https://en.wikipedia.org/wiki/List_of_Internet_top-level_domains). Each TLD has its own Registry that manages it and defines its IDN rules.
* [Wikipedia for Domain Name Registry](https://en.wikipedia.org/wiki/Domain_name_registry), like Verisign
* [Wikipedia for Domain Name Registrar](https://en.wikipedia.org/wiki/Domain_name_registrar), like Namecheap, Godaddy, or Gandi.net
* [ICANN Accreditation and Verisign Certification](https://www.verisign.com/en_US/channel-resources/become-a-registrar/verisign-domain-registrar/index.xhtml) for distributing .com domains
* [Wikipedia for the Extensible Provisioning Protocol](https://en.wikipedia.org/wiki/Extensible_Provisioning_Protocol), which is used when a user on a registry requests a .com domain. The registry uses the EPP protocol to communicate with verisign to register the domain.
* [Verisign's IDN Policy](https://www.verisign.com/en_US/channel-resources/domain-registry-products/idn/idn-policy/registration-rules/index.xhtml). Verisign requires you specify a three letter language tag associated with the domain upon registration. this tag determines which character scripts you can use in the domain. presumably the language tag for https://аррӏе.com/ (cyrillic) is 'RUS' or 'UKR'.
* [PIR, manager of .org TLDs, IDN rules](https://pir.org/products/org-domain/org-idns/)

## Misc Security related to Domains

* [Extended Validation Is Broken by @iangcarroll](https://stripe.ian.sh/)

## Examples

* http://аоӏ.com/
* https://раураӏ.com/
* https://аррӏе.com/
* http://www.спп.com/