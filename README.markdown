Git Authentication Manager
===========================

Why another authentication system
---------------------------------

Using an git-repository in enterprise or company environment is difficult because you have to manage many users. Also you have an central authentication system like MS Active Directory, Crowd, etc and you probably would like to integrate it with git repo (gitosis/gitolite).

You know that gitosis/gitolite can use ssh or http(s) for authentication.

Http(s) can be easily integrated with LDAP, Crowd or something else. But you have on critical limitation:

> You have to always enter login/password. One workaround for this is store login/password in .netrc  or .curlrc file, but only in plaintext. It is not secure





 * Which method of authentication to use? Gitosis/Gitolite provides ssh and http(s)?
 * 
 * If I use http(s) I have to store plain text password in netrc/curlrc or have to enter password each time I pull/push changes.
> If I choose ssh and store my public key I still get access

Goals
-----

Requirements
------------
 * Git (client)
 * List item
 * Ruby 1.8.x/1.9.x
 * Gems
   * daemons
   * ruby-ldap
   * git

Install
-------
