From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 3/3] tpm: vtpm_proxy: Add ioctl to request locality
 prepended to command
Date: Wed, 10 May 2017 15:47:45 +0300
Message-ID: <20170510124745.lmqvonrkjmjes7ep@intel.com>
References: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1493384538-27883-4-git-send-email-stefanb@linux.vnet.ibm.com>
 <20170503223747.zefh76m4youqlgje@intel.com>
 <40cd7d48-f6d1-39f4-99a3-916c7cdbb636@linux.vnet.ibm.com>
 <20170504091738.rxl77hjzf6vnpuda@intel.com>
 <e8408f9b-d53d-5af0-3678-e851d78ba99e@linux.vnet.ibm.com>
 <20170504184007.46efvqyqwxjkzwuq@intel.com>
 <daa25807-53cd-1abd-d2fa-57e01e37da9f@linux.vnet.ibm.com>
 <20170508234328.iydmoverh5z4nwco@intel.com>
 <c4bf7270-1243-bf14-7da8-95d2691ce445@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c4bf7270-1243-bf14-7da8-95d2691ce445@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, LSM List <linux-security-module@vger.kernel.org>, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, May 09, 2017 at 11:49:05AM -0400, Stefan Berger wrote:
> On 05/08/2017 07:43 PM, Jarkko Sakkinen wrote:
> > On Thu, May 04, 2017 at 04:03:18PM -0400, Stefan Berger wrote:
> > > On 05/04/2017 02:40 PM, Jarkko Sakkinen wrote:
> > > > On Thu, May 04, 2017 at 07:14:27AM -0400, Stefan Berger wrote:
> > > > > On 05/04/2017 05:17 AM, Jarkko Sakkinen wrote:
> > > > > > On Wed, May 03, 2017 at 07:40:48PM -0400, Stefan Berger wrote:
> > > > > > > On 05/03/2017 06:37 PM, Jarkko Sakkinen wrote:
> > > > > > > > On Fri, Apr 28, 2017 at 09:02:18AM -0400, Stefan Berger wrote:
> > > > > > > > > Add an ioctl to request that the locality be prepended to every TPM
> > > > > > > > > command.
> > > > > > > > Don't really understand this change. Why locality is prenpended?
> > > > > > > Commands can be executed under locality 0-3 and for some commands it is
> > > > > > > important to know which locality a user may have chosen. How else should we
> > > > > > > convey that locality to the TPM emulator ?
> > > > > > Why this is not in the commit message?
> > > > > > 
> > > > > > More scalable way to do this would be to have a set of vtpm proxy
> > > > > > commands. There could be a command for requesting and releasing
> > > > > > locality. That would be more clean.
> > > > > I would think that if someone wanted to use locality it's the client using
> > > > > /dev/tpm(rm)0 calling an ioctl or so and the vtpm proxy then merely passing
> > > > > that locality to the backend (TPM emulator). I suppose the intention is to
> > > > > support something like that following the addition of the new functions
> > > > > request_locality and release_locality?
> > > > What if we later on want to pass something else than locality to the
> > > > backend? How that will work out?
> > > 'push' more data in front. 'pop' off by recipient. We could wrap the command
> > > in some form.
> > > 
> > >      Stefan
> > I would find having a set of special commands cleaner. Prepending sounds
> > like a quick hack to me, not really something that should exist in the
> > mainline.
> 
> Along the lines of this here?
> 
> uint32_2 command
> uint32_2 totlength
> uint8_t locality
> uint8_t buffer[]  <- the actual TPM command
> 
> 
> With a command code like VTPM_PROXY_CMD_TPM_CMD = 1.
> 
>    Stefan

That would break binary compability.

I would suggest allocating CC's backwards starting from 0xFFFFFFFF for
these control messages and send them in regular TPM command layout. A
bit similar idea as we have in the RM.

/Jarkko
