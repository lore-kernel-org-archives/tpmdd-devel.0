From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v4] tpm_crb: request and relinquish locality 0
Date: Sat, 25 Mar 2017 21:52:11 +0200
Message-ID: <20170325195211.w2gfmodozgwrfxy6@intel.com>
References: <20170324101032.13496-1-jarkko.sakkinen@iki.fi>
 <87lgru7cqy.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lgru7cqy.fsf@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>, tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, gang.wei@intel.com, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Mar 24, 2017 at 11:25:57AM -0700, Jerry Snitselaar wrote:
> 
> Jarkko Sakkinen @ 2017-03-24 10:10 GMT:
> 
> > This commit adds support for requesting and relinquishing locality 0 in
> > tpm_crb for the course of command transmission.
> >
> > In order to achieve this, two new callbacks are added to struct
> > tpm_class_ops:
> >
> > - request_locality
> > - relinquish_locality
> >
> > With CRB interface you first set either requestAccess or relinquish bit
> > from TPM_LOC_CTRL_x register and then wait for locAssigned and
> > tpmRegValidSts bits to be set in the TPM_LOC_STATE_x register.
> >
> > The reason why were are doing this is to make sure that the driver
> > will work properly with Intel TXT that uses locality 2. There's no
> > explicit guarantee that it would relinquish this locality. In more
> > general sense this commit enables tpm_crb to be a well behaving
> > citizen in a multi locality environment.
> >
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> Tested-by: Jerry Snitselaar <jsnitsel@redhat.com>
> 
> Tested on kabylake system that was hitting issues with earlier
> iteration. Still don't have platform to test it dealing with
> multi-locality enviroment.

I believe Jimmy (Gang Wei) has done such testing. Jimmy can you confirm
and possibly do re-test (there's a locality branch in my tree to ease
the testing) so that we could land this one?

/Jarkko
