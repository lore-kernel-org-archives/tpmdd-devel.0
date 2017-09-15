From: Joe Perches <joe@perches.com>
Subject: Re: New ML for TPM and IMA
Date: Fri, 15 Sep 2017 10:25:36 -0700
Message-ID: <1505496336.27581.7.camel@perches.com>
References: <20170915171825.5zjit5vsrvxgmvrb@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170915171825.5zjit5vsrvxgmvrb@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-09-15 at 10:18 -0700, Jarkko Sakkinen wrote:
> Hi
> 
> Many people were kicked out from the SourceForge mailing list in the
> July because SF required a resubscription, including non-human users,
> such as patchwork.
> 
> We decided to create a new mailing list linux-integrit@vger.kernel.org
> to cover both TPM and IMA since they tend to have cross dependencies.
> Otherwise, the maintainer hierarchy etc. will stay the same.
> 
> It is all documented here:
> 
> http://kernsec.org/wiki/index.php/Linux_Kernel_Integrity
> 
> From now on use this list for patches and discussion instead of the
> legacy list.

And is there to be an update to the MAINTAINERS file entries?

Extended Verification Module (EVM)
L:	linux-ima-devel@lists.sourceforge.net
L:	linux-security-module@vger.kernel.org

INTEGRITY MEASUREMENT ARCHITECTURE (IMA)
L:	linux-ima-devel@lists.sourceforge.net
L:	linux-ima-user@lists.sourceforge.net
L:	linux-security-module@vger.kernel.org

TPM DEVICE DRIVER
L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)

TPM IBM_VTPM DEVICE DRIVER
L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)


