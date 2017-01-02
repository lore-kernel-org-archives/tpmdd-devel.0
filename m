From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Mon, 02 Jan 2017 08:36:20 -0800
Message-ID: <1483374980.2458.13.camel@HansenPartnership.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-02 at 15:22 +0200, Jarkko Sakkinen wrote:
> This patch set adds support for TPM spaces that provide a context
> for isolating and swapping transient objects. This patch set does
> not yet include support for isolating policy and HMAC sessions but
> it is trivial to add once the basic approach is settled (and that's
> why I created an RFC patch set).

The approach looks fine to me.  The only basic query I have is about
the default: shouldn't it be with resource manager on rather than off? 
 I can't really think of a use case that wants the RM off (even if
you're running your own, having another doesn't hurt anything, and it's
still required to share with in-kernel uses).

> There's a test script for trying out TPM spaces in
> 
>   git://git.infradead.org/users/jjs/tpm2-scripts.git
> 
> A simple smoke test can be run by
> 
>   sudo python -m unittest -v tpm2_smoke.SpaceTest   

I've also added an enabling patch to the tss

https://build.opensuse.org/package/view_file/home:jejb1:Tumbleweed/tss2/0002-tssProperties-add-TPM_USE_RESOURCE_MANAGER.patch?expand=1

And with that, I've TPM 2 enabled both gnome-keyring and openssl:

https://build.opensuse.org/package/show/home:jejb1:Tumbleweed/gnome-keyring
https://build.opensuse.org/package/show/home:jejb1:Tumbleweed/openssl_tpm_engine

I'm running them in production on my day to day laptop and so far
everything's working nicely (better than 1.2, in fact, since tcsd
periodically crashes necessitating a restart of everything).

So you can definitely add my Tested-By.

James

