From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v5 3/3] tpm: add securityfs support for
 TPM 2.0 firmware event log
Date: Sat, 26 Nov 2016 17:24:23 +0200
Message-ID: <20161126152423.becdi2defihydtpm@intel.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479922057-8752-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20161124211057.xynmfteky5r7uc27@intel.com>
	<11f97863-aa40-a9aa-836f-4b446faf1ed3@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <11f97863-aa40-a9aa-836f-4b446faf1ed3-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 24, 2016 at 09:51:03PM -0500, Stefan Berger wrote:
> On 11/24/2016 04:10 PM, Jarkko Sakkinen wrote:
> > On Wed, Nov 23, 2016 at 12:27:37PM -0500, Nayna Jain wrote:
> > > Unlike the device driver support for TPM 1.2, the TPM 2.0 does
> > > not support the securityfs pseudo files for displaying the
> > > firmware event log.
> > > 
> > > This patch enables support for providing the TPM 2.0 event log in
> > > binary form. TPM 2.0 event log supports a crypto agile format that
> > > records multiple digests, which is different from TPM 1.2. This
> > > patch enables the tpm_bios_log_setup for TPM 2.0  and adds the
> > > event log parser which understand the TPM 2.0 crypto agile format.
> > > 
> > > Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > I don't want to say much about this before I've tested it. I wonder
> > what cheap hardware I could use to test this. Any advice is on this
> > from anyone is much appreciated.
> 
> Virtual hardware would be cheap :-)
> 
> I tested this series with QEMU + vTPM + SeaBIOS with TPM 1.2 + TPM 2 support
> (basing the log on ACPI). I had to fix an endianess issue on the SeaBIOS
> side, which made it work. So for this version of the patches I can give it
> my tested-by:
> 
> Tested-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Your Tested-by is much appreciated because the 4.10 release cycle has
shown how important it is to exercise code changes with tpm_vtpm_proxy
to catch all the regressions. I still would like to run these changes
with a real hardware to be able to trust them, though.

/Jarkko

------------------------------------------------------------------------------
