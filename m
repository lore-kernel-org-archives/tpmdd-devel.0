From: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 0/4] Extend TPM 2.0 PCR banks each with
 corresponding digest
Date: Wed, 5 Apr 2017 15:23:57 +0530
Message-ID: <58E4BEB5.8030509@linux.vnet.ibm.com>
References: <20170329102452.32212-1-roberto.sassu@huawei.com>
	<58DCCCD3.7010300@linux.vnet.ibm.com>
	<212fdaf4-f5f3-8615-bb5a-7f21864e33e1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <212fdaf4-f5f3-8615-bb5a-7f21864e33e1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 03/30/2017 04:37 PM, Roberto Sassu wrote:
> On 3/30/2017 11:16 AM, Nayna wrote:
>> Why can't we export existing tpm2_pcr_extend() and use that directly ?
>
> tpm2_pcr_extend() requires the tpm_chip structure, which is
> not exposed outside. Translation from chip_num to tpm_chip
> should be done in tpm-interface.c (see tpm_seal_trusted()).

I was thinking why are we not changing tpm2_pcr_extend() itself to 
accept chip_num, but now I see how it is done in tpm_seal_trusted().

Thanks !!

Thanks & Regards,
    - Nayna

>
> Roberto
>


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
