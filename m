From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 0/3]  Extend the vTPM proxy driver to pass locality to
 emulator
Date: Thu, 4 May 2017 01:38:49 +0300
Message-ID: <20170503223849.qcoc6xqncbyi6jwj@intel.com>
References: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, jgunthorpe@obsidianresearch.com, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Apr 28, 2017 at 09:02:15AM -0400, Stefan Berger wrote:
> The purpose of this series of patches is to enable the passing of the locality
> a command is executing in to a TPM emulator. To enable this we introduce a new
> flag for the device creation ioctl that requests that the locality be prepended
> to every command. For applications to check which flags the driver supports, we
> add a new ioctl that returns a bitmask of supported flags.

This is a weird change proposal as you could use tpm_vtpm_proxy for
other than some TPM emulator.

> 
> v1->v2:
>   - fixed return value from function in patch 3/3
> 
> 
> Stefan Berger (3):
>   tpm: vtpm_proxy: Add ioctl to get supported flags
>   tpm: vtpm_proxy: Implement request_locality
>   tpm: vtpm_proxy: Add ioctl to request locality prepended to command
> 
>  drivers/char/tpm/tpm_vtpm_proxy.c | 53 +++++++++++++++++++++++++++++++++++----
>  include/uapi/linux/vtpm_proxy.h   | 15 ++++++++++-
>  2 files changed, 62 insertions(+), 6 deletions(-)
> 
> -- 
> 2.4.3
> 

/Jarkko
