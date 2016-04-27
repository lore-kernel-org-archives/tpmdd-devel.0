From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v11 0/4] Multi-instance vTPM proxy driver
Date: Wed, 27 Apr 2016 15:56:21 +0300
Message-ID: <20160427125621.GA3026@intel.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160422165427.GA24090@intel.com>
 <20160426092807.GA32066@intel.com>
 <571F5152.7000901@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <571F5152.7000901@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Apr 26, 2016 at 07:30:26AM -0400, Stefan Berger wrote:
> On 04/26/2016 05:28 AM, Jarkko Sakkinen wrote:
> >On Fri, Apr 22, 2016 at 07:54:27PM +0300, Jarkko Sakkinen wrote:
> >>On Mon, Apr 18, 2016 at 01:26:12PM -0400, Stefan Berger wrote:
> >>>The following series of patches implements a multi-instance vTPM
> >>>proxy driver that can dynamically create TPM 'server' and client device
> >>>pairs.
> >>>
> >>>Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
> >>>and a server side file descriptor is created. The file descriptor must
> >>>be passed to a TPM emulator. The device driver will initialize the
> >>>emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
> >>>the command durations from the device in case of a TPM 1.2. The choice
> >>>of emulated TPM device (1.2 or 2) must be provided with a flag in
> >>>the ioctl.
> >>>
> >>>The patches are based on the tip of a recent checkout of Jarkko's tree
> >>>(master branch).
> >>I've applied this series to my master branch. These patches have been
> >>baking long enough in my opinion that they could be merged to next and
> >>therefore find their way into Linux 4.7
> >>
> >>Stefan, I would still require your Tested-by for the first patch before
> >>merging because it is not as mature as other patches are.
> >Now I have augmented Tested-by's to relevant patches and added my
> >Signed-off-by's. I plan to merge this to the next branch tomorrow.
> 
> Please don't forget Jason's patch for tpm_tis.c that fixes the device used
> in the devm_request_irq/devm_free_irq calls. The rmmod of tpm_tis only work
> correctly in interrupt mode when that patch is applied.

It has been merged already earlier to the next branch. I've now merged
these patches to the next branch.

>    Stefan

/Jarkko
