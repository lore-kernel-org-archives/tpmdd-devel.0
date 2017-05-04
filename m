From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Extend the vTPM proxy driver to
 pass locality to emulator
Date: Thu, 4 May 2017 12:18:27 +0300
Message-ID: <20170504091827.6yzmttjf2kxeen4l@intel.com>
References: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20170503223849.qcoc6xqncbyi6jwj@intel.com>
	<72bacff5-5213-b114-ebf4-6e3fe7284bdc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <72bacff5-5213-b114-ebf4-6e3fe7284bdc-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, May 03, 2017 at 07:42:06PM -0400, Stefan Berger wrote:
> On 05/03/2017 06:38 PM, Jarkko Sakkinen wrote:
> > On Fri, Apr 28, 2017 at 09:02:15AM -0400, Stefan Berger wrote:
> > > The purpose of this series of patches is to enable the passing of the locality
> > > a command is executing in to a TPM emulator. To enable this we introduce a new
> > > flag for the device creation ioctl that requests that the locality be prepended
> > > to every command. For applications to check which flags the driver supports, we
> > > add a new ioctl that returns a bitmask of supported flags.
> > This is a weird change proposal as you could use tpm_vtpm_proxy for
> > other than some TPM emulator.
> 
> I think in most cases the recipient of the TPM commands from the vtpm_proxy
> driver will be a TPM emulator. What do you have in mind?

Like using Intel SGX to implement TPM in ring-3. I've thought
vtpm_tpm_proxy as generic proxy that you can also use for emulators.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
