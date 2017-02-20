From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: declare tpm2_get_pcr_allocation() as
 static
Date: Mon, 20 Feb 2017 13:20:03 +0200
Message-ID: <20170220112003.jv732fizul27edjm@intel.com>
References: <20170215180228.25650-1-jarkko.sakkinen@linux.intel.com>
 <20170217102427.427h3qxwajocilji@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170217102427.427h3qxwajocilji@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net, Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Feb 17, 2017 at 12:24:27PM +0200, Jarkko Sakkinen wrote:
> On Wed, Feb 15, 2017 at 08:02:28PM +0200, Jarkko Sakkinen wrote:
> > There's no need to export tpm2_get_pcr_alloation() because it is only
> > a helper function for tpm2_auto_startup(). For the same reason it does
> > not make much sense to maintain documentation for it.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Nayna, does this look good to you?

I guess I'll just include this to the pull request as it is an obvious
glitch.

/Jarkko
