From: James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] tpmdd fixes for Linux 4.5
Date: Tue, 9 Feb 2016 11:59:57 +1100 (AEDT)
Message-ID: <alpine.LRH.2.20.1602091159440.6966@namei.org>
References: <20160119233903.GA12337@intel.com> <20160208204610.GA14626@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160208204610.GA14626@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 8 Feb 2016, Jarkko Sakkinen wrote:

> James,
> 
> On Wed, Jan 20, 2016 at 01:39:03AM +0200, Jarkko Sakkinen wrote:
> > Hi James,
> > 
> > This pull request contains three small cleanups, a bug fix for policy
> > based sealing, a bug fix for attach/detach of the platform device for
> > tpm_tis and resource locking for tpm_tis and tpm_crb.
> 
> I have 3-4 small scope fixes for the release that have been implemented
> after this.
> 
> Since it's bee a while since this pull request should I create a new one
> and include those or do you want to pull this first?
> 
> I could rebase that new pull request to -rc3 to which security/next is
> now rebased.
> 

The latter is probably best.


-- 
James Morris
<jmorris@namei.org>
