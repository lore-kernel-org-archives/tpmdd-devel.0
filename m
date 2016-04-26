From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v11 0/4] Multi-instance vTPM proxy driver
Date: Tue, 26 Apr 2016 12:28:07 +0300
Message-ID: <20160426092807.GA32066@intel.com>
References: <1461000376-2888-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160422165427.GA24090@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160422165427.GA24090@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Apr 22, 2016 at 07:54:27PM +0300, Jarkko Sakkinen wrote:
> On Mon, Apr 18, 2016 at 01:26:12PM -0400, Stefan Berger wrote:
> > The following series of patches implements a multi-instance vTPM 
> > proxy driver that can dynamically create TPM 'server' and client device
> > pairs.
> > 
> > Using an ioctl on the provided /dev/vtpmx, a client-side vTPM device
> > and a server side file descriptor is created. The file descriptor must
> > be passed to a TPM emulator. The device driver will initialize the
> > emulated TPM using TPM 1.2 or TPM 2 startup commands and it will read
> > the command durations from the device in case of a TPM 1.2. The choice
> > of emulated TPM device (1.2 or 2) must be provided with a flag in
> > the ioctl.
> > 
> > The patches are based on the tip of a recent checkout of Jarkko's tree
> > (master branch).
> 
> I've applied this series to my master branch. These patches have been
> baking long enough in my opinion that they could be merged to next and
> therefore find their way into Linux 4.7
> 
> Stefan, I would still require your Tested-by for the first patch before
> merging because it is not as mature as other patches are.

Now I have augmented Tested-by's to relevant patches and added my
Signed-off-by's. I plan to merge this to the next branch tomorrow.

> /Jarkko

/Jarkko
