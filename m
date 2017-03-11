From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH RFC,v2] tpm_crb: request and relinquish locality 0
Date: Sat, 11 Mar 2017 14:38:09 +0200
Message-ID: <20170311123809.pa6gdh3tbdvcod55@intel.com>
References: <20170311105339.19486-1-jarkko.sakkinen@linux.intel.com>
 <20170311105543.gkj46ktz6kup3bu5@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170311105543.gkj46ktz6kup3bu5@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, Jerry Snitselaar <jsnitsel@redhat.com>, gang.wei@intel.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Mar 11, 2017 at 12:55:43PM +0200, Jarkko Sakkinen wrote:
> On Sat, Mar 11, 2017 at 12:53:36PM +0200, Jarkko Sakkinen wrote:
> > Added two new callbacks to struct tpm_class_ops:
> > 
> > - request_locality
> > - relinquish_locality
> > 
> > These are called before sending and receiving data from the TPM.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> > This not yet v2 of this patch. I'm checking that this is what needs to be done
> > for tpm_tis_core before I go through testing etc. Thank you.
> 
> And apparently I did not amend tpm-interface.c change :( Anyway, I'm
> merely sanity checking that I'm doing the right thing.

If check_locality fails request_locality returns locality number
but it's not used for anything. Would it be OK to change it to
just return -EBUSY in this case?

/Jarkko
