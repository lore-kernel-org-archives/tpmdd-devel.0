From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 1/4] tpm/tpm_crb: implement tpm crb
	idle state
Date: Wed, 14 Sep 2016 19:05:02 +0300
Message-ID: <20160914160441.GA11131@intel.com>
References: <1473670501-29281-1-git-send-email-tomas.winkler@intel.com>
	<1473670501-29281-2-git-send-email-tomas.winkler@intel.com>
	<20160912120109.GA957@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542CDCB7@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542CDCB7-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Sep 12, 2016 at 12:25:21PM +0000, Winkler, Tomas wrote:
> > Also, I don't like the naming. I would rather have the names I did for [1].
> > There I have 'go_to_idle' and 'go_to_ready', which are much more obvious.
> > I'm can live also with go_ready and go_idle if you prefer that.
> 
> go_idle and cmd_ready follow the TMP2 spec 

'goIdle' and 'cmdReady' are CRB specific (PTP spec). I think here it
would make sense to have readable names. 'cmd_ready' sounds like it
would be return a status code or something.

I'm open for other suggestions than the ones that I proposed abouve
but cmd_ready sounds like it would return a status code.
`
> > Please use wait_for_tpm_stat(). Please argument in th commit message if
> > you don't. So far the arguments haven't made sense to me.
> 
> I say it again this should not go via tpm_stat this is conceptually
> wrong.  Second why would you want to use such complex function that
> also cumulates side effects for simple polling of register that should
> be used at one place. Plus other reason I've mentioned before.
> 
> Last you need 'struct tpm_chip' available which just not the case here.

I do agree that the status callback and these masks that we have is a
mess.

I think the tpmdd should migrate to simple design where would have
common synthetized status codes like

enum tpm_chip_status {
	TPM_CHIP_READY = BIT(0),
	TPM_CHIP_IDLE = BIT(1),
	TPM_CHIP_CANCELED = BIT(2), /* also idle */
};

(you might want to wait for two possible end states, that's why bits 
 for states is a better idea than increasing number)

However, until we have such thing, it would make sense not to introduce
redundant code or go through the longer path and fix the status code
handling.

/Jarkko

------------------------------------------------------------------------------
