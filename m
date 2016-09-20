From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v3 0/7] tpm: TPM2.0 eventlog securityfs
 support
Date: Tue, 20 Sep 2016 13:04:23 +0300
Message-ID: <20160920100423.GB32433@intel.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830101611.GA11819@intel.com>
	<OFFF1DBFC5.1719C0A6-ON00258033.00514374-85258033.005192C5@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OFFF1DBFC5.1719C0A6-ON00258033.00514374-85258033.005192C5-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, philip.b.tricca-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 19, 2016 at 10:50:15AM -0400, Stefan Berger wrote:
>    > You also fail to explain how this should work with ACPI even though
>    > we know that there does not exist any kind for event log through ACPI
>    > with TPM 2.0 hardware. I.e. just by reading the commits I can obviously
>    > see that you are doing major untested code path changes.
> 
>    That's true there there's not spec for a BIOS at the moment and I would
>    expect that TCG will likely not write one. Likely all vendors have moved
>    on to (U)EFI. We realized this also while implementing TPM 2 support for
>    SeaBIOS and I ended up reusing the ACPI TCPA table but adopted the EFI
>    specified log format with that special first entry. Can we accomodate that
>    ?

Does that match to "SHA1 Event Log Entry Format" defined in [1]? In
addition "Crypto Agile Log Entry Format" must be supported.

Philip: what was the UEFI handover procedure that was discussed in
TPM BoF at LSS 2016?

>       Stefan

[1] http://www.trustedcomputinggroup.org/wp-content/uploads/EFI-Protocol-Specification-rev13-160330final.pdf

/Jarkko

------------------------------------------------------------------------------
