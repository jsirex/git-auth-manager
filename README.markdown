Git Authentication Manager
===========================

Why another authentication system
---------------------------------

Using an git-repository in enterprise or company endvironment is difficult because you have to manage many users. Also you have an central authentication system like MS Active Directory, Crowd, etc and you probably would like to integrate it with git repo (gitosis/gitolite).

You know that gitosis/gitolite can use ssh or http(s) for authentication.

Http(s) can be easily integrated with LDAP, Crowd or something else. But you have one critical limitation:

> You have to always enter login/password. One workaround for this is store login/password in .netrc  or .curlrc file, but only in plaintext. It is not secure

SSH provides you nice security and nice access to the repository trhough ssh-keys. I think that SSH is better choice instead
HTTP. But:

> SSHd server ignores information from your central authentication system. For example, if you disable account in MS AD
> user still be able to work with repository.

That's why I've decided to write an daemon which will control and sync users from an authentication system to git repository.

Goals
-----
Actually we have only one major goal: automatically disable user in git-repository when it has been disabled or expired in
central authentication system.

Requirements
------------
 * Git (client)
 * Ruby 1.8.x/1.9.x
 * Gems (Can be bundled)
   * daemons
   * ruby-ldap
   * git
 * libsasl2-dev

Install
-------

 0. Clone remote repository: `git clone https://github.com/jsirex/git-auth-manager.git`
 0. Install dev packages of `libldap2` and `libsasl2`
 0. Use `bundle install` or install required gems manually
 0. Copy `config.yml.sample` to `config.yml`
 0. Configure your daemon through `config.yml`
 0. Start/Stop daemon using `ruby control.rb start` or `ruby control.rb stop`
 
If you want to run daemon manually you can use `ruby git-auth-manager.rb`. Flag `--do-not-loop` tells program to sync users once and exit

