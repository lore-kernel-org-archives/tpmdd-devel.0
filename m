From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] tpm: vtpm_proxy: Add ioctl to
 request locality prepended to command
Date: Thu, 4 May 2017 12:17:38 +0300
Message-ID: <20170504091738.rxl77hjzf6vnpuda@intel.com>
References: <1493384538-27883-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1493384538-27883-4-git-send-email-stefanb@linux.vnet.ibm.com>
	<20170503223747.zefh76m4youqlgje@intel.com>
	<40cd7d48-f6d1-39f4-99a3-916c7cdbb636@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <40cd7d48-f6d1-39f4-99a3-916c7cdbb636-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Wed, May 03, 2017 at 07:40:48PM -0400, Stefan Berger wrote:
> On 05/03/2017 06:37 PM, Jarkko Sakkinen wrote:
> > On Fri, Apr 28, 2017 at 09:02:18AM -0400, Stefan Berger wrote:
> > > Add an ioctl to request that the locality be prepended to every TPM
> > > command.
> > Don't really understand this change. Why locality is prenpended?
> 
> Commands can be executed under locality 0-3 and for some commands it is
> important to know which locality a user may have chosen. How else should we
> convey that locality to the TPM emulator ?

Why this is not in the commit message?

More scalable way to do this would be to have a set of vtpm proxy
commands. There could be a command for requesting and releasing
locality. That would be more clean.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
