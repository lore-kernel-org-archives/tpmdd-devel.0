From: Christophe Ricard <christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 11/12] tpm/tpm_tis: Split tpm_tis
 driver into a core and TCG TIS compliant phy
Date: Wed, 13 Apr 2016 22:55:25 +0200
Message-ID: <570EB23D.8000904@gmail.com>
References: <1460577351-24632-1-git-send-email-christophe-h.ricard@st.com>
	<1460577351-24632-12-git-send-email-christophe-h.ricard@st.com>
	<20160413204842.GD3836@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160413204842.GD3836-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: jean-luc.blanc-qxv4g6HH51o@public.gmane.org, ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, christophe-h.ricard-qxv4g6HH51o@public.gmane.org, Peter Huewe <peter.huewe-d0qZbvYSIPpWk0Htik3J/w@public.gmane.org>, benoit.houyere-qxv4g6HH51o@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net



On 13/04/2016 22:48, Jason Gunthorpe wrote:
> On Wed, Apr 13, 2016 at 09:55:50PM +0200, Christophe Ricard wrote:
>
>> +EXPORT_SYMBOL_GPL(release_locality);
> All exports need better names to avoid namespace
> collisions. tpm_tis_release_locatity perhaps?
Do you think tpm_tis_core shouldn't be renamed tpm_tis and tpm_tis 
renamed tpm_tis_lpc ?
This way it would be a bit more explicit exported symbol starting with 
tpm_tis_ comes from tpm_tis.
What do you think ?
My only cons is that "tpm_tis_lpc" would work as well with a SPI tpms 
through "FED4xxxx" addressing like.
>> +SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
>> +EXPORT_SYMBOL_GPL(tpm_tis_pm);
> Hum, not sure that is a good idea... That stuff should probably be in
> each driver?
Yes i agree with that. I wanted to see people reactions.
>> @@ -52,7 +106,6 @@ struct tpm_tis_data {
>>   	const struct tpm_tis_class_lowlevel *lowlevel;
>>   	const struct tpm_tis_phy_ops *phy_ops;
>>   	void *phy_id;
>> -	int (*post_probe)(struct tpm_chip *chip);
> Please clean up your patches so rebase mistakes like this are not included.
Yes sorry. My bad :(.
> Jason


------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
