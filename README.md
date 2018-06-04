# rapier
An open-source, safe, sandboxed scripting language for Web automation.

## Why?
The Rapier language is the backbone of an upcoming desktop program called
`Rapier Desktop`.

Rapier Desktop is primarily targeted at end-users, not developers, and will present
a clean, attractive UI that users can use to run programs they have purchased from
the Rapier Marketplace.

These programs are intended specifically for Web automation. That is to say, Rapier
will be primarily used for things like shopping bots and Web UI testing.

Rapier Desktop will also provide UI to store data like credit card information, addresses,
and proxies, that can be used across applications.

The Rapier language is ultimately a framework that handles things like running headless
browsers, submitting forms, processing CAPTCHA's, switching through proxies, and other
tasks that present large development costs ordinarily. Developing a bot in Rapier will
ensure an audience of potential customers, sizeable profits, and **trust** from users,
in addition to extremely shortened development time, a powerful static analyzer that diagnoses
bugs before even running code, and open-source developer support.

## How is it secure?
Because Rapier will often be touching sensitive data, but interacting with that
data via third-party code, all code must be treated as untrusted. That is to say,
**no code in Rapier can touch sensitive data without explicit user consent**.

For example, in a bot that uses the user's credit card and address to fill in a shopping
form, not only must the hostname because explicitly mentioned in `rapier.json`, but the
user must also manually approve of sending sensitive data to the host.

Furthermore, the `print` function cannot display sensitive data. There is no chance of
a malicious program somehow reverse-engineering the system to dump your CC info and harvest
it.

In addition, sensitive data **cannot** be placed in a browser or HTTP requqest that is not
already allowed to handle sensitive data.

Ultimately, security in Rapier is handled by granting little to no privileges to
programs, ever.

## How will it be funded?
Rapier programs will be distributed by means of a Web portal called the `Rapier Marketplace`.
Programs here will get the benefit of an App Store-like experience, and integration into
the `Rapier Desktop`. Programs cannot be distributed outside of the marketplace. This,
although it is a walled garden, *ensures* security for all parties through an auditing
and error-checking process that verifies that all programs work and run as expected.

Funding will come as follows:
* One-time registration fee for developers
* Optional fee to promote a program within its category
* Percentage taken from program sales